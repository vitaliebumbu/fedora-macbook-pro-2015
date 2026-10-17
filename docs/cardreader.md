# Internal card-reader reconnect trial

On2026-10-16 the Apple05ac:8406 card reader repeatedly disconnected/re-enumerated at USB2-4 with no SD card inserted. User heard paired tones around21:46, matching21:46:21–22 kernel events. Sound source is strongly correlated, not directly captured. No reader autosuspend was active (`power/control=on`), but USB3 U1/U2 link power saving was enabled.

Applied a targeted trial: disable U1/U2 for the internal root-hub port occupied by this reader. The helper verifies vendor/product and direct root-hub topology, discovers the matching port and writes0 to its `usb3_lpm_permit`. Readback0 and both U1/U2 disabled verified. It leaves the reader usable and other USB ports unchanged. May increase reader power consumption. No claim of proven repair or identified root cause yet; monitor for recurrent disconnects during normal use.

Install `cardreader/disable-link-power-saving.py` as `/usr/local/sbin/macbook-cardreader-no-lpm` mode755 and `cardreader/91-macbook-cardreader.rules` in `/etc/udev/rules.d/` mode644; restore SELinux contexts and reload udev rules. To apply immediately invoke the helper with the reader sysfs path as root. The rule applies on device addition after reboot/reconnect. Udev rule validation passed. Do not apply to other hardware without checking topology.

Rollback: remove the installed rule, reload rules, and write `u1_u2` to the affected port's `usb3_lpm_permit` (this machine `/sys/bus/usb/devices/usb2/2-0:1.0/usb2-port4/usb3_lpm_permit`) as root, or reboot after rule removal. Earlier charger mute was separately reverted at user request.

[Kernel USB sysfs documentation](https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-bus-usb) describes the port-specific USB3 link-power control. SD card read/write, suspend/wake, reboot persistence and long-term stability remain untested for this trial.
