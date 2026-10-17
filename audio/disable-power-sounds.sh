#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.local/share/sounds/quiet-power"
mkdir -p "$DEST/stereo"
cp "$HERE/quiet-power/index.theme" "$DEST/index.theme"
touch "$DEST/stereo/power-plug.disabled" "$DEST/stereo/power-unplug.disabled"
gsettings set org.gnome.desktop.sound theme-name quiet-power
