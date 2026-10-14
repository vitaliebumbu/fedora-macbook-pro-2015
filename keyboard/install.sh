#!/usr/bin/env bash
# Set hid_apple fnmode=1 so MacBook media keys work without Fn.
# Persists across reboots (writes /etc/modprobe.d/hid_apple.conf and
# rebuilds the initramfs). Applies live too — no reboot needed for
# the current session.

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    exec sudo -- "$0" "$@"
fi

CONF=/etc/modprobe.d/hid_apple.conf
SYSFS=/sys/module/hid_apple/parameters/fnmode

echo "options hid_apple fnmode=1" > "$CONF"
echo "wrote: $CONF"

if [[ -w "$SYSFS" ]]; then
    echo 1 > "$SYSFS"
    echo "applied live: fnmode=$(cat "$SYSFS")"
else
    echo "note: hid_apple is not currently loaded — change will apply at next boot."
fi

echo "rebuilding initramfs..."
if command -v dracut >/dev/null 2>&1; then
    dracut --force
elif command -v update-initramfs >/dev/null 2>&1; then
    update-initramfs -u
elif command -v mkinitcpio >/dev/null 2>&1; then
    mkinitcpio -P
else
    echo "warning: no known initramfs tool found (dracut, update-initramfs, mkinitcpio)."
    echo "the runtime change is in effect, but the setting may not survive reboot."
    echo "rebuild your distro's initramfs manually."
    exit 1
fi

echo
echo "done. tap volume / brightness / keyboard-backlight keys without Fn to test."
echo "press Fn+F1..F12 when you actually want a function key."
