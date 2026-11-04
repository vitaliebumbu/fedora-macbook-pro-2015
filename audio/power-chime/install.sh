#!/usr/bin/env bash
# Install the Mac charger chime and mute GNOME's own power event sounds.
#
#   ./install.sh              chime on plug/unplug + mute GNOME power events
#   ./install.sh --mute-only  only mute GNOME's power-plug/power-unplug
#
# No root required.
set -euo pipefail

src=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

mode=full
case "${1:-}" in
    --mute-only) mode=mute ;;
    "") ;;
    *) printf 'usage: %s [--mute-only]\n' "${0##*/}" >&2; exit 2 ;;
esac

bin="$HOME/.local/bin"
share="$HOME/.local/share/power-chime"
unitdir="$HOME/.config/systemd/user"
sounds="$HOME/.local/share/sounds/quiet-power"
theme=quiet-power

install_theme() {
    install -d -m755 "$sounds/stereo"
    install -m644 "$src/theme/power-plug.oga"   "$sounds/stereo/power-plug.oga"
    install -m644 "$src/theme/power-unplug.oga" "$sounds/stereo/power-unplug.oga"
    rm -f "$sounds/stereo/"*.disabled

    if ! command -v gsettings >/dev/null 2>&1; then
        printf 'gsettings not found; installed the theme but did not select it.\n' >&2
        return
    fi

    local current parent
    current=$(gsettings get org.gnome.desktop.sound theme-name 2>/dev/null | tr -d "'" || true)
    if [[ ! -f $sounds/index.theme ]]; then
        parent=$current
        case $parent in
            ""|"$theme") parent=freedesktop ;;
        esac
        printf '[Sound Theme]\nName=Quiet Power\nInherits=%s\nDirectories=stereo\n\n[stereo]\nOutputProfile=stereo\n' \
            "$parent" > "$sounds/index.theme"
    fi
    if [[ $current != "$theme" ]]; then
        gsettings set org.gnome.desktop.sound theme-name "$theme"
    fi
}

install_theme
if [[ $mode == mute ]]; then
    printf 'Muted GNOME power-plug/power-unplug events through the %s sound theme.\n' "$theme"
    exit 0
fi

install -d -m755 "$bin" "$share" "$unitdir"
install -m755 "$src/power-chimed"     "$bin/power-chimed"
install -m755 "$src/power-chime-play" "$bin/power-chime-play"
install -m644 "$src/power-chime.service" "$unitdir/power-chime.service"
install -m644 "$src/README.md" "$share/README.md"

if [[ ! -s $share/connect_power.wav ]]; then
    tmp=$(mktemp --tmpdir power-chime.XXXXXX.wav)
    trap 'rm -f "$tmp"' EXIT
    printf 'Extracting the Apple chime from the macOS IPSW (a few MB, network required)...\n'
    if ! "$src/tools/extract-attach-chime.py" --device "${POWER_CHIME_BOARD:-j293}" -o "$tmp"; then
        printf 'Extraction failed. Put a 48 kHz stereo WAV at %s and re-run.\n' \
            "$share/connect_power.wav" >&2
        exit 1
    fi
    install -m644 "$tmp" "$share/connect_power.wav"
fi

# Same sound in both directions. Real Macs only chime on connect; set
# POWER_CHIME_ON_UNPLUG=0 in the unit to match that.
install -m644 "$share/connect_power.wav" "$share/disconnect_power.wav"

systemctl --user daemon-reload
systemctl --user enable power-chime.service
systemctl --user restart power-chime.service

printf '\nInstalled.\n'
printf '  test:   power-chime-play connect\n'
printf '  status: systemctl --user status power-chime.service\n'
printf '  logs:   journalctl --user -u power-chime.service -f\n'
