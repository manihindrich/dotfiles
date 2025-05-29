# My desktop dotfiles

There is a script [init-demo.sh](./init-demo.sh) that securely integrates dotfiles into the Linux system. Everything in it is configurable using variables. This repository is solely a public-demo branch for sharing dotfile management practices across devices. My actual dotfiles are kept only on a local Git server, and I don't find it suitable to put them entirely on GitHub.

## Variables

- `f` as file
- `sd` as source directory
- `td` as target directory
- `s` as search in the file
- `a` as add to the file

## Execution

### Create a symlink

```bash
echo -e "\n# Create a symlink for .bashrc.user"
f=".bashrc.user"; td="$HOME"; sd="."; 
sdc=$(realpath --relative-to="$td" "$(pwd)/$sd"); [ -e "$td/$f" ] && [ ! -L "$td/$f" ] && mv "$td/$f" "$td/$f.bak" && echo "File $f.bak created." || { [ -L "$td/$f" ] && echo "File $f is a symlink." || echo "File $f does not exist."; }; [ ! -L "$td/$f" ] && { ln -s "$sdc/$f" "$td/$f" && echo "Symlink created: $td/$f → $sdc/$f"; }
```

#### Command Logic

* **Announces intent** and defines file paths (`.bashrc.user`, `$HOME`, current directory `.` ).
* **Checks `$HOME/.bashrc.user`:**
    * **If it exists and isn't a symlink**, it's moved to a `.bak` backup.
    * Otherwise, it reports if it's already a symlink or doesn't exist.
* **Creates a symlink** from `./.bashrc.user` to `$HOME/.bashrc.user`, if a symlink isn't already present.

### Add record to

```bash
echo -e "\n# Add record to .bashrc"
f=".bashrc"; td="$HOME";
s='. "$HOME/.bashrc.user"'; a=$'\n# User custom configuration\n. "$HOME/.bashrc.user"';
grep -F "$s" "$td/$f" >/dev/null 2>&1 && echo "Entry already exists." || { echo -e "$a" >> "$td/$f" && echo "Entry added to $td/$f"; }
```

#### Command Logic

* **Announces intent** to add a record to `.bashrc` and defines paths.
* **Checks if the entry already exists** in `$HOME/.bashrc`:
    * If **yes**, it reports "Entry already exists."
    * If **no**, it appends the new entry (a comment and `.` sourcing `$HOME/.bashrc.user`) to `$HOME/.bashrc` and confirms it was added.
