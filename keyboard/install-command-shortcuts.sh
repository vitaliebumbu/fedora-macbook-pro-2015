#!/usr/bin/env bash
# Swap Command and Control, retaining independent Fn configuration.
set -euo pipefail
[[ $EUID == 0 ]] || { echo "Run with sudo bash $0" >&2; exit 1; }
config=/etc/modprobe.d/hid_apple-command.conf
[[ ! -e "$config" ]] || cp -a "$config" "$config.backup-$(date +%Y%m%d-%H%M%S)"
script_dir=$(cd -- "$(dirname -- "$0")" && pwd)
install -m644 "$script_dir/command-shortcuts.conf" "$config"
echo 1 > /sys/module/hid_apple/parameters/swap_ctrl_cmd
dracut --force --kver "$(uname -r)"
echo 'Now run bash screenshots/install.sh as your desktop user to retain Command screenshot shortcuts.'
