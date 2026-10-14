#!/usr/bin/env bash
set -euo pipefail
CONF="$HOME/.config/gascroll.conf"
if [ -f "$CONF" ]; then sed -i 's/^enabled=.*/enabled=0/' "$CONF"; fi
rm -f "$HOME/.config/systemd/user/org.gnome.Shell@user.service.d/60-touchpad-scroll.conf"
systemctl --user daemon-reload
printf 'Disabled. Log out and back in to unload the library.\n'
