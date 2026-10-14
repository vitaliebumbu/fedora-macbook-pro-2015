# Lid-close suspend

Installed policy (`suspend/10-lid-suspend.conf`):

```ini
[Login]
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=suspend
HandleLidSwitchDocked=ignore
```

Closing the lid suspends on battery or external power. Docked operation keeps running; external displays and GNOME's own lid handling may affect what is considered docked or which component handles the event.

## Apply

Back up any existing file, then:

```bash
sudo install -Dm644 suspend/10-lid-suspend.conf /etc/systemd/logind.conf.d/10-lid-suspend.conf
sudo systemctl kill -s HUP systemd-logind
systemctl is-enabled sleep.target suspend.target
```

If these targets are masked unintentionally, unmask them:

```bash
sudo systemctl unmask sleep.target suspend.target
```

Unmasking does not itself configure hibernation. Leave deliberate administrator restrictions in place until their purpose is understood.

## Camera sleep/wake workaround

The installed `camera/scripts/facetimehd-unload.service` unloads the camera driver before `sleep.target` and reloads it once the sleep service is no longer needed after resume.

```bash
sudo install -m644 camera/scripts/facetimehd-unload.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable facetimehd-unload.service
```

This service requires the camera module to be installed. An open camera application can prevent module removal. Diagnose service failures before relying on suspend.

## Test and undo

Save work, test `systemctl suspend`, resume, then test lid close/open on battery and AC. Inspect `journalctl -b -u systemd-logind -u facetimehd-unload.service`. Policy and service enablement were confirmed at publication; a physical suspend/resume cycle was not performed in this consolidation.

To undo, restore your previous logind snippet and reload it. Restore prior camera service state and contents from your backup; do not restart logind unnecessarily during an active desktop session.
