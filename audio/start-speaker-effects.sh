#!/usr/bin/env bash
set -euo pipefail
# Start processing service, then select the approved speaker preset.
easy_pid=""
if ! pgrep -f "^easyeffects --service-mode$" >/dev/null; then
    easyeffects --service-mode &
    easy_pid=$!
fi
sleep 1
for attempt in {1..20}; do
    if timeout 2 easyeffects -a output >/dev/null 2>&1; then break; fi
    sleep 1
done
if pactl list sinks | grep -q 'Active Port: analog-output-speaker'; then
    timeout 10 easyeffects -l MacBook-Warm-Smooth-Balanced-Bass
    timeout 10 easyeffects -b 2
else
    timeout 10 easyeffects -b 1
fi
if [ -n "$easy_pid" ]; then wait "$easy_pid"; fi
