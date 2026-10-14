#!/usr/bin/env bash
set -euo pipefail
BACKUP="$HOME/.local/state/fedora-macbook-pro-2015/pointer-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"
for device in mouse touchpad; do dconf dump "/org/gnome/desktop/peripherals/$device/" > "$BACKUP/$device.dconf"; done
gsettings set org.gnome.desktop.peripherals.touchpad accel-profile adaptive
gsettings set org.gnome.desktop.peripherals.touchpad speed -0.15
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad click-method fingers
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad tap-and-drag true
gsettings set org.gnome.desktop.peripherals.touchpad tap-and-drag-lock false
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing true
gsettings set org.gnome.desktop.peripherals.mouse accel-profile adaptive
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll true
printf 'Applied. Backup: %s\n' "$BACKUP"
