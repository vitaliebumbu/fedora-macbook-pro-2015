#!/usr/bin/env bash
set -euo pipefail
# Only recover a missing controller while BlueZ is running.
/usr/bin/systemctl is-active --quiet bluetooth.service || exit 0
healthy() {
    local controllers
    controllers=$(/usr/bin/timeout 5 /usr/bin/bluetoothctl list 2>/dev/null) || return 1
    [[ "$controllers" == *"Controller "* ]]
}
healthy && exit 0
# Match this MacBook's Bluetooth USB hardware, never another USB device.
count=0
for device in /sys/bus/usb/devices/*; do
    [[ -f "$device/idVendor" && -f "$device/idProduct" ]] || continue
    if [[ "$(cat "$device/idVendor")" == 05ac && "$(cat "$device/idProduct")" == 8290 ]]; then
        count=$((count + 1))
    fi
done
if [[ "$count" != 1 ]]; then
    echo "Bluetooth recovery skipped: expected one 05ac:8290 device, found $count" >&2
    exit 0
fi
# Allow delayed initialization to finish before touching hardware.
sleep 5
healthy && exit 0
echo "Bluetooth controller unavailable; resetting 05ac:8290 once"
/usr/bin/timeout 10 /usr/bin/usbreset 05ac:8290
for attempt in {1..10}; do
    sleep 2
    if healthy; then
        echo "Bluetooth controller recovered"
        exit 0
    fi
done
echo "Bluetooth recovery unsuccessful; retry deferred to next timer check" >&2
exit 1
