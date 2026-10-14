# Fan control

The machine has `mbpfan.service` enabled and active. The backed-up configuration starts cooling earlier:

```ini
[general]
low_temp = 55
high_temp = 60
max_temp = 86
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
