#!/bin/bash

# Check if the script is run from the 'dotfiles' directory
[ "$(basename "$(pwd)")" != "dotfiles" ] && echo "ERROR: This script must be run from the 'dotfiles' directory." && exit 1
# Dotfile deployment incoming: Have you commented out the bits that don't spark joy?
read -p "Have you commented out everything you don't want to change in your home? (y/N):" -n 1 -r REPLY; echo; [[ ! $REPLY =~ ^[yY]$ ]] && echo "Operation aborted by user." && exit 1

# Bash
echo -e "\n# Create a symlink for .bashrc.user"
f=".bashrc.user"; td="$HOME"; sd="."; 
sdc=$(realpath --relative-to="$td" "$(pwd)/$sd"); [ -e "$td/$f" ] && [ ! -L "$td/$f" ] && mv "$td/$f" "$td/$f.bak" && echo "File $f.bak created." || { [ -L "$td/$f" ] && echo "File $f is a symlink." || echo "File $f does not exist."; }; [ ! -L "$td/$f" ] && { ln -s "$sdc/$f" "$td/$f" && echo "Symlink created: $td/$f → $sdc/$f"; }

echo -e "\n# Add record to .bashrc"
f=".bashrc"; td="$HOME";
s='. "$HOME/.bashrc.user"'; a=$'\n# User custom configuration\n. "$HOME/.bashrc.user"';
grep -F "$s" "$td/$f" >/dev/null 2>&1 && echo "Entry already exists." || { echo -e "$a" >> "$td/$f" && echo "Entry added to $td/$f"; }
