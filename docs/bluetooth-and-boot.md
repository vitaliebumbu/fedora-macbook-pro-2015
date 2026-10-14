# Bluetooth and reboot tuning

## Delayed initialization

The recorded MacBook Bluetooth setup blacklists automatic early `btusb` loading, disables its USB autosuspend option, and explicitly loads the module after the display manager starts. A USB rule keeps power control enabled for Apple device `05ac:8290`.

The original oneshot service slept for 15 seconds and held `multi-user.target` on the critical chain. The new timer preserves delayed loading without that target waiting for the sleep:

- `macbook-bluetooth.service`: original service backup.
- `20-nonblocking-startup.conf`: replaces its commands with just `modprobe btusb`.
- `macbook-bluetooth.timer`: ordered after the display manager, fires after 15 seconds with 1-second timer accuracy.

Back up the corresponding system files and enablement state before applying:

```bash
sudo install -m644 bluetooth/macbook-bluetooth.conf /etc/modprobe.d/
sudo install -m644 bluetooth/90-macbook-bluetooth.rules /etc/udev/rules.d/
sudo install -m644 bluetooth/macbook-bluetooth.service bluetooth/macbook-bluetooth.timer /etc/systemd/system/
sudo install -Dm644 bluetooth/20-nonblocking-startup.conf /etc/systemd/system/macbook-bluetooth.service.d/20-nonblocking-startup.conf
sudo systemctl daemon-reload
sudo systemctl disable macbook-bluetooth.service
sudo systemctl enable macbook-bluetooth.timer
sudo udevadm control --reload-rules
sudo dracut --force --kver "$(uname -r)"
```

The service condition uses this machine's `/sys/bus/usb/devices/1-8`; inspect your USB topology before copying it. Do not force module unloading during active Bluetooth use. The timer changes are intended for the next boot.

## GRUB

Changed `GRUB_TIMEOUT=5` to `GRUB_TIMEOUT=1` in `/etc/default/grub`, then ran:

```bash
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo grub2-script-check /boot/grub2/grub.cfg
```

On current Fedora the EFI `grub.cfg` is a forwarding stub; do not overwrite it. Existing automatic menu hiding and recovery behavior were retained. Actual waiting depends on boot-success flags; this change is not a guaranteed four-second saving on every boot.

## Measurement

Before the change: kernel 0.724s + initrd 2.463s + userspace 18.397s = **21.585s**. `graphical.target` reached at 18.346s, while GDM started around 3.193s. Firmware/bootloader time was not reported. Target timing does not equal visible desktop readiness.

Previous shutdown logs captured roughly two seconds, with no long service timeout. NetworkManager wait-online took 63ms and was left enabled. No global shutdown timeout was reduced.

After the next reboot:

```bash
systemd-analyze
systemd-analyze critical-chain
systemctl status macbook-bluetooth.timer macbook-bluetooth.service
bluetoothctl show
```

Unit validation and GRUB syntax passed. Reboot speed and Bluetooth functionality after these changes remain untested.

## Rollback

Disable the timer, remove the added timer/drop-in, restore prior Bluetooth files and enablement, reload systemd and udev, and rebuild the affected initramfs. Restore your prior `/etc/default/grub` and regenerate GRUB. Back up before applying so rollback preserves your own earlier settings.

## Automatic missing-controller recovery

After a reboot produced BCM reset timeout -110, a targeted USB reset recovered the controller. Added `bluetooth/recover-controller.sh`, `macbook-bluetooth-recovery.service` and `.timer`.

Install the script as `/usr/local/sbin/macbook-bluetooth-recovery` mode755 and both units in `/etc/systemd/system/` mode644; restore SELinux contexts, run `systemctl daemon-reload`, then `systemctl enable --now macbook-bluetooth-recovery.timer` as root. Requires bluetoothctl and usbreset (already present on this workstation).

The timer checks45 seconds after boot and every2 minutes. It only acts while bluetooth.service is active and no controller is listed. Requires exactly one USB device with vendor/product05ac:8290, waits5 seconds for initialization, then resets that device once and checks for recovery. A healthy or merely powered-off listed controller is untouched. No system reboot, module unload, BlueZ restart or pairing deletion. No controller-name matches means recovery is skipped. Reset commands and checks have timeouts; service maximum100 seconds.

Verified unit syntax, installed contexts, timer enablement and real healthy-controller exit0. An isolated simulated missing-controller test produced exactly one reset and detected recovery. Actual recovery during a future reboot failure remains untested; the prior manual USB reset succeeded. It covers controller enumeration failure, not every pairing or connection fault.

Inspect `journalctl -u macbook-bluetooth-recovery.service` and `systemctl list-timers macbook-bluetooth-recovery.timer`. Rollback: `systemctl disable --now macbook-bluetooth-recovery.timer`; leave script/unit files inactive or remove them and daemon-reload. Existing delayed Bluetooth initialization remains in place.

## Remove desktop Wi-Fi startup wait — 2026-10-14

Latest measured boot15.268s; NetworkManager-wait-online took3.932s, network-online reached at7.554s userspace and user sessions waited until7.566s. GDM followed user sessions. No NFS/CIFS mounts or remote filesystems in fstab were found. Disabled `NetworkManager-wait-online.service` with `systemctl disable`; NetworkManager remains active and Wi-Fi connected. No connection profile, Wi-Fi powersave or Bluetooth setting changed.

This lets the desktop proceed before Wi-Fi activation finishes. Network-dependent jobs may now start before connectivity exists. Re-enable with `sudo systemctl enable NetworkManager-wait-online.service` if adding boot-critical remote mounts/services. Approximately4 seconds of wait was a candidate for removal, not a measured improvement: next reboot and visible login timing remain pending. Plymouth quit-wait was left unchanged because it follows graphical readiness; shortening its accounting alone does not prove faster usable startup.

Reference: [NetworkManager wait-online documentation](https://networkmanager.dev/docs/api/latest/NetworkManager-wait-online.service.html).
