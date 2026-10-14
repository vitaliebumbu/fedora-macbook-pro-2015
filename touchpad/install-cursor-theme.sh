#!/usr/bin/env bash
set -euo pipefail
SOURCE="$HOME/.local/share/WhiteSur-cursors-source"
if [ ! -d "$SOURCE/.git" ]; then git clone https://github.com/vinceliuice/WhiteSur-cursors "$SOURCE"; fi
git -C "$SOURCE" fetch origin e190baf618ed95ee217d2fd45589bd309b37672b
git -C "$SOURCE" checkout --detach e190baf618ed95ee217d2fd45589bd309b37672b
mkdir -p "$HOME/.local/share/icons/WhiteSur-cursors"
cp -a "$SOURCE/dist/." "$HOME/.local/share/icons/WhiteSur-cursors/"
gsettings set org.gnome.desktop.interface cursor-theme WhiteSur-cursors
gsettings set org.gnome.desktop.interface cursor-size 24
