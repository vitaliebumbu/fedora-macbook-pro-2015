#!/usr/bin/env bash
# Remove the charger chime and restore GNOME's normal power event sounds.
set -euo pipefail

share="$HOME/.local/share/power-chime"
unit="$HOME/.config/systemd/user/power-chime.service"
sounds="$HOME/.local/share/sounds/quiet-power"

systemctl --user disable --now power-chime.service 2>/dev/null || true
rm -f "$unit"
rm -f "$HOME/.local/bin/power-chimed" "$HOME/.local/bin/power-chime-play"
rm -rf "$share"

if [[ -f $sounds/index.theme ]]; then
    parent=$(sed -n 's/^Inherits=//p' "$sounds/index.theme" | head -n 1)
    [[ -n $parent ]] || parent=freedesktop
    if command -v gsettings >/dev/null 2>&1; then
        current=$(gsettings get org.gnome.desktop.sound theme-name 2>/dev/null | tr -d "'" || true)
        if [[ $current == quiet-power ]]; then
            gsettings set org.gnome.desktop.sound theme-name "$parent"
        fi
    fi
fi
rm -rf "$sounds"

systemctl --user daemon-reload
printf 'Removed the charger chime and restored the previous sound theme.\n'
