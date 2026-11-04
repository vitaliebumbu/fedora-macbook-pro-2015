#!/usr/bin/env bash
# Mute GNOME's power-plug/power-unplug event sounds, keeping other event
# sounds.  Shortcut for: audio/power-chime/install.sh --mute-only
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
exec "$HERE/power-chime/install.sh" --mute-only
