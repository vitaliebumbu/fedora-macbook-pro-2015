#!/usr/bin/bash
. /usr/lib/tuned/functions
start() { disable_wifi_powersave; }
stop() { return 0; }
process "$@"
