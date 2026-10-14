#!/usr/bin/env bash
# Revert: remove the hid_apple fnmode override and restore the kernel default.

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    exec sudo -- "$0" "$@"
fi

CONF=/etc/modprobe.d/hid_apple.conf
SYSFS=/sys/module/hid_apple/parameters/fnmode

if [[ -f "$CONF" ]]; then
    rm -f "$CONF"
    echo "removed: $CONF"
else
    echo "no config to remove at $CONF"
fi

if [[ -w "$SYSFS" ]]; then
    # 3 = auto, the kernel default
    echo 3 > "$SYSFS"
    echo "restored live: fnmode=$(cat "$SYSFS") (auto)"
fi

echo "rebuilding initramfs..."
if command -v dracut >/dev/null 2>&1; then
    dracut --force
elif command -v update-initramfs >/dev/null 2>&1; then
    update-initramfs -u
elif command -v mkinitcpio >/dev/null 2>&1; then
    mkinitcpio -P
else
    echo "warning: no known initramfs tool found. rebuild it manually for your distro."
fi

echo "done."
