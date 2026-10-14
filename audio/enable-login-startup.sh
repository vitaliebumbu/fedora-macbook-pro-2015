#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$HOME/.local/bin" "$HOME/.config/autostart"
install -m 755 "$HERE/start-speaker-effects.sh" "$HOME/.local/bin/start-speaker-effects"
cat > "$HOME/.config/autostart/macbook-speaker-effects.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=MacBook Speaker Effects
Exec="$HOME/.local/bin/start-speaker-effects"
Terminal=false
X-GNOME-Autostart-enabled=true
EOF
