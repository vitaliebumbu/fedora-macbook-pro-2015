#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
LIB="$HOME/.local/lib/libgascroll.so"
CONF="$HOME/.config/gascroll.conf"
DROPIN="$HOME/.config/systemd/user/org.gnome.Shell@user.service.d/60-touchpad-scroll.conf"
mkdir -p "$(dirname "$LIB")" "$(dirname "$CONF")" "$(dirname "$DROPIN")"
gcc -shared -fPIC -O2 -Wall -Wextra -o "$LIB.tmp" "$HERE/gascroll.c" -ldl -lm
mv -f "$LIB.tmp" "$LIB"
if [ -f "$CONF" ]; then cp -a "$CONF" "$CONF.backup-$(date +%Y%m%d-%H%M%S)"; fi
cp "$HERE/gascroll.conf" "$CONF"
printf '[Service]\nEnvironment="LD_PRELOAD=%s"\nEnvironment="GASCROLL_CONF=%s"\n' "$LIB" "$CONF" > "$DROPIN"
systemctl --user daemon-reload
printf 'Installed. Log out and back in to activate.\n'
