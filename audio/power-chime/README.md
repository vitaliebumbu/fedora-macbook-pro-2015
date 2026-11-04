# Charger chime

Apple's charger chime on power connect and disconnect, with GNOME's own
`power-plug` / `power-unplug` event sounds muted so only one sound is heard.
Runs as a systemd user service; no root required.

Setup notes, verification, and limits: [docs/audio.md](../../docs/audio.md#charger-chime--2026-11-03).

## Install

```bash
./install.sh
```

The first install extracts the chime from Apple's macOS restore image over
HTTP range requests, so it needs `python3` and network access to Apple's CDN.
Apple's audio is not stored in this repository. Put a 48 kHz stereo WAV at
`~/.local/share/power-chime/connect_power.wav` beforehand to skip extraction.

The installer also adds the `quiet-power` sound theme (inheriting the theme
already selected) and selects it, which silences GNOME's power events without
touching other event sounds.

## Test

```bash
power-chime-play connect
systemctl --user status power-chime.service
journalctl --user -u power-chime.service -f
```

Unplug and replug the charger; the journal should log `power removed -> chime`
and `power connected -> chime`.

## Tuning

Edit the unit with `systemctl --user edit power-chime.service`, then
`systemctl --user restart power-chime.service`.

| Variable | Default | Meaning |
| --- | --- | --- |
| `POWER_CHIME_VOLUME` | `1.0` | stream volume, 0–1 |
| `POWER_CHIME_ON_UNPLUG` | `1` | `0` for plug-in only, like a real Mac |
| `POWER_CHIME_SUPPLY` | `ADP1` | AC node under `/sys/class/power_supply` |
| `POWER_CHIME_POLL` | `0.25` | seconds between polls |

Replace `~/.local/share/power-chime/connect_power.wav` (and
`disconnect_power.wav`) to use another sound.

If a different sound theme is selected later in GNOME Tweaks, GNOME's power
sound returns; re-run `./install.sh` or select `quiet-power` again.

## Mute only

```bash
./install.sh --mute-only
```

Installs just the sound-theme override. `audio/disable-power-sounds.sh` is kept
as a shortcut for this mode.

## Uninstall

```bash
./uninstall.sh
```

Removes the service, scripts, chime and `quiet-power` theme, and restores the
theme that `quiet-power` inherited.
