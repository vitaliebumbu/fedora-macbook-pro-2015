#!/usr/bin/env bash
# Run as the desktop user, without sudo.
set -euo pipefail
[[ $EUID != 0 ]] || { echo 'Run as your desktop user, without sudo.' >&2; exit 1; }
backup="${XDG_STATE_HOME:-$HOME/.local/state}/fedora-macbook-pro-2015"
mkdir -p "$backup"
dconf dump /org/gnome/shell/keybindings/ > "$backup/screenshot-bindings-$(date +%Y%m%d-%H%M%S).dconf"
gsettings set org.gnome.shell.keybindings screenshot "['<Shift>Print', '<Super><Shift>3']"
gsettings set org.gnome.shell.keybindings screenshot-window "['<Alt>Print', '<Super><Shift><Alt>4']"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['Print', '<Super><Shift>4', '<Super><Shift>5']"
