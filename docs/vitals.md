# Vitals panel widget

[Vitals](https://github.com/corecoding/Vitals) adds system monitoring to the GNOME top panel, including temperatures, fan speeds, memory, CPU load, and network activity. It displays sensor readings; it does not control fans or replace mbpfan.

## Recorded workstation setup

Checked on 2026-10-13:

- Extension UUID: `Vitals@CoreCoding.com`.
- Installed version: **85**; GNOME Shell **50.5**.
- Extension reported **Enabled: Yes** and **State: ACTIVE**.
- Selected panel sensor: processor temperature (`_temperature_processor_0_`).
- Panel position: left (`position-in-panel=0`).
- Public-IP lookup disabled (`include-public-ip=false`).
- Menu centering disabled (`menu-centered=false`).

These are the recorded preference overrides, not all default settings. Sensor identifiers can differ on other machines. Extension activity was verified; the accuracy of temperature readings was not independently measured.

## Install on another Fedora GNOME system

The upstream Fedora instructions list these support packages:

```bash
sudo dnf install libgtop2-devel lm_sensors
```

Install a compatible Vitals release from the [GNOME Extensions listing](https://extensions.gnome.org/extension/1460/vitals/) using its browser integration or Extension Manager. If GNOME does not see the newly installed extension on Wayland, log out and back in after saving work.

```bash
gnome-extensions enable Vitals@CoreCoding.com
gnome-extensions info Vitals@CoreCoding.com
```

Open preferences with `gnome-extensions prefs Vitals@CoreCoding.com`. Choose available sensors there if the backed-up processor sensor is not present.

## Restore this panel configuration

After installing Vitals, run as your desktop user:

```bash
bash vitals/restore-settings.sh
```

The script saves prior preference overrides under `~/.local/state/fedora-macbook-pro-2015/`, merges [vitals/settings.dconf](../vitals/settings.dconf), and enables the extension. It does not download or install extension code, change unrelated GNOME settings, or reset unspecified Vitals preferences.

## Undo

Disable with `gnome-extensions disable Vitals@CoreCoding.com`. To restore the exact previous preference overrides, reset only the Vitals subtree and load the saved backup:

```bash
dconf reset -f /org/gnome/shell/extensions/vitals/
dconf load /org/gnome/shell/extensions/vitals/ < YOUR_BACKUP_FILE
```

Choose the correct backup file first. This restores preferences, not the extension's previous enabled state.

The extension remains maintained upstream; this repository backs up its configuration and documents installation rather than redistributing the extension.
