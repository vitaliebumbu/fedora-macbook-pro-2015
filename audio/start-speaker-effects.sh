#!/usr/bin/env bash
set -euo pipefail
easy_pid=""
if ! pgrep -f "^easyeffects --service-mode$" >/dev/null; then
    easyeffects --service-mode &
    easy_pid=$!
fi
# Audio devices and application settings may appear after desktop startup.
sleep 3
for attempt in {1..30}; do
    if pactl --format=json list sinks > "${XDG_RUNTIME_DIR}/macbook-speaker-sinks.json" 2>/dev/null &&
       python3 - "${XDG_RUNTIME_DIR}/macbook-speaker-sinks.json" <<'CHECK'
import json,sys
sinks=json.load(open(sys.argv[1]))
sys.exit(0 if any(s.get('name')=='alsa_output.pci-0000_00_1b.0.analog-stereo' for s in sinks) else 1)
CHECK
    then break; fi
    sleep 1
done
if python3 - "${XDG_RUNTIME_DIR}/macbook-speaker-sinks.json" <<'CHECK'
import json,sys
sinks=json.load(open(sys.argv[1]))
sys.exit(0 if any(s.get('name')=='alsa_output.pci-0000_00_1b.0.analog-stereo' and s.get('active_port')=='analog-output-speaker' for s in sinks) else 1)
CHECK
then
    for attempt in {1..10}; do
        timeout 5 easyeffects -l MacBook-Warm-Smooth-Balanced-Bass || true
        timeout 5 easyeffects -b 2 || true
        if [[ "$(timeout 5 easyeffects -a output)" == *MacBook-Warm-Smooth-Balanced-Bass* ]] &&
           [[ "$(timeout 5 easyeffects -b 3)" == *2* ]]; then break; fi
        sleep 1
    done
else
    timeout 10 easyeffects -b 1
fi
rm -f "${XDG_RUNTIME_DIR}/macbook-speaker-sinks.json"
if [ -n "$easy_pid" ]; then wait "$easy_pid"; fi
