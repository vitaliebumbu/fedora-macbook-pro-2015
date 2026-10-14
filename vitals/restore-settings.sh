#!/usr/bin/env bash
# Run in the GNOME desktop session, without sudo, after installing Vitals.
set -euo pipefail
[[ $EUID != 0 ]] || { echo 'Run as your desktop user, without sudo.' >&2; exit 1; }
gnome-extensions info Vitals@CoreCoding.com >/dev/null
script_dir=$(cd -- "$(dirname -- "$0")" && pwd)
backup="${XDG_STATE_HOME:-$HOME/.local/state}/fedora-macbook-pro-2015"
mkdir -p "$backup"
dconf dump /org/gnome/shell/extensions/vitals/ > "$backup/vitals-$(date +%Y%m%d-%H%M%S).dconf"
dconf load /org/gnome/shell/extensions/vitals/ < "$script_dir/settings.dconf"
gnome-extensions enable Vitals@CoreCoding.com
echo "Vitals preferences merged. Previous overrides saved under $backup."
