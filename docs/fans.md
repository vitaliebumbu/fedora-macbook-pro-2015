# Fan control

The machine has `mbpfan.service` enabled and active. The backed-up configuration starts cooling earlier:

```ini
[general]
min_fan1_speed = 3500
min_fan2_speed = 3500
low_temp = 50
high_temp = 55
max_temp = 80
polling_interval = 1
```

`mbpfan` reads Apple SMC fan information and CPU temperature sensors; the existing system installer loaded `applesmc` and `coretemp` and built mbpfan from source. This repository includes the active settings and service, not a copied mbpfan source distribution.

Obtain mbpfan from your distribution if available, or follow the licensed upstream build instructions at https://github.com/linux-on-mac/mbpfan. Confirm `/usr/sbin/mbpfan` exists before using the backed-up service.

After backing up your previous fan configuration:

```bash
sudo install -m644 fans/mbpfan.conf /etc/mbpfan.conf
sudo install -m644 fans/mbpfan.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now mbpfan.service
systemctl status mbpfan.service
```

These settings are hardware-specific. Service activity was checked, but temperatures, fan noise, and behavior under sustained load were not benchmarked here. Preserve firmware emergency cooling and restore your prior configuration if this tuning does not suit your machine.

## Cooler operation — 2026-10-14

At user request, changed thresholds from55/60/86 to50/55/80 C, with minimum3500RPM on both fans. Hardware maxima remain6156/5700RPM. Fans ramp above55 C and run at maximum above80 C; this does not cap CPU temperature at80 C. Below50 C they return to the configured3500RPM minimum. Expect more fan noise and some additional fan power use. Existing macbook-powersave/Turbo-disabled configuration and thermald retained; no extra CPU limit applied.

Original config backup `/etc/mbpfan.conf.backup-20261014-005340`. Rollback: restore this file to `/etc/mbpfan.conf`, then restart mbpfan. Enabled service makes the new settings persistent. Baseline short sample58–62 C, initial ramp-only followup64–65 C with no throttling; varying workload means this is not a controlled temperature comparison. Higher temperatures during sustained load remain possible.

Final15s check with fan floor: maximum CPU sensor62–63 C, fans approximately3940/3830RPM. Service active; reboot with this exact config not yet tested.
