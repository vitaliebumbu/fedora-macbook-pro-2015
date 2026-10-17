# Built-in speaker audio

The MacBook uses the Cirrus CS4208 analog stereo speaker output through PipeWire/WirePlumber. Speaker channels were active and no software effects were present at the start of investigation.

On 2026-10-14 EasyEffects 8.2.8 and its plugins were installed. A conservative EQ trial was loaded and stereo routing verified. The user preferred the previous sound, so the trial was bypassed and EasyEffects quit. Final routing was verified directly from Firefox to the physical stereo speaker output. No EasyEffects autostart, output-volume increase, or persistent EQ startup was configured. The experiment was not accepted as a sound-quality improvement.

The inactive trial remains locally available but is not the recommended default. Any further tuning should start with listening feedback and a level-matched bypass comparison; software processing cannot establish acoustic quality without listening or measurement.

An initial release-only package installation selected older Qt and multimedia packages. These were immediately upgraded from the updates repository. Final verified versions include Qt6 base 6.11.2, GStreamer good 1.28.8, and mediawriter 5.3.2. Use all current Fedora repositories when installing EasyEffects; do not reproduce the release-only installation.

EasyEffects can be launched from the application menu if manual experimentation is wanted. Its bypass and quit controls restore direct playback. Do not automatically apply speaker tuning to headphones.

## Warm Music audition

User requested a warmer alternative. Created `audio/MacBook-Warm-Music.json` and loaded it successfully in EasyEffects. Stereo Firefox routing through the equalizer to the built-in speakers was verified. No autostart or output-volume increase was enabled. Listening acceptance remains pending.

The four bell bands are 180 Hz +2 dB, 450 Hz +0.5 dB, 3 kHz -0.75 dB, and 8 kHz -1.5 dB, with -3 dB input headroom. The intention is modest lower-mid warmth and softer treble, without boosting sub-bass. This is a subjective starting point, not measured speaker calibration or a hardware protection system.

Copy the JSON into `~/.local/share/easyeffects/output/`, start EasyEffects, and load `MacBook-Warm-Music`. Compare with bypass at similar perceived loudness. Run `easyeffects --bypass 1` to bypass, `easyeffects --bypass 2` to enable processing, or quit EasyEffects to restore direct playback. Use this preset only for the built-in speakers; headphones may need different tuning.

## Warm Smooth — compact-speaker-inspired audition

Loaded `audio/MacBook-Warm-Smooth.json` at the user's request for a Sonos-like tonal balance. This is an original subjective preset, not Sonos calibration or a claim to reproduce its acoustic response.

Chain: Warm Music's modest EQ with -4 dB input headroom, gentle downward compression (-18 dB threshold, 1.6:1 ratio, 25 ms attack, 150 ms release, +1.5 dB makeup), then a stereo-linked -1 dB limiter with automatic gain boost disabled. No deep-bass boost or stereo widening. The limiter limits digital peaks; it is not physical speaker protection.

Preset load and stereo EQ → compressor → limiter routing verified. Listening acceptance, loudness matching, and distortion measurement remain pending. No autostart configured. Restore `MacBook-Warm-Music` or bypass processing for comparison.

## Warm Smooth Bass audition

Loaded `audio/MacBook-Warm-Smooth-Bass.json` for fuller perceived bass. Both channels use a 130 Hz +2.5 dB bell with -5 dB EQ input headroom. Gentle harmonic bass enhancement follows the EQ (amount -6 dB, harmonics 3, scope 160 Hz, floor 80 Hz enabled, output -1 dB), followed by the existing compressor and limiter.

Preset selection and stereo routing through bass enhancement, compressor, and limiter verified. Listening quality and distortion remain untested. Small speakers cannot reproduce deep sub-bass through EQ alone. Output volume and autostart were unchanged. Load `MacBook-Warm-Smooth` to restore the previous audition, or bypass for direct comparison.

## Bass Plus audition

The initial bass variant was not noticeably different to the listener. Firefox routing through all effects was confirmed. Loaded `MacBook-Warm-Smooth-Bass-Plus`: 160 Hz +4 dB bell, -6 dB EQ headroom, bass enhancer amount 0 dB and scope 200 Hz, enhancer output 0 dB. Compressor and limiter retained. Previous presets retained; no physical volume or autostart change. New listening and distortion checks pending.

## Warm Smooth Balanced Bass audition

Loaded `MacBook-Warm-Smooth-Balanced-Bass` for a compromise between Warm Smooth and Bass Plus. Uses a 160 Hz +3 dB bell with -5.5 dB EQ input headroom; gentle bass enhancement amount -3 dB, scope 180 Hz, output -0.5 dB. Other EQ bands, compressor and limiter retained. Previous presets remain available. No output-volume or autostart change. Preset selection and stereo routing verified. The user approved this preset on 2026-10-14; it is the preferred built-in speaker preset. Distortion measurement remains unperformed. This is subjective tuning, not measured Sonos calibration.

To reload the preferred preset, start EasyEffects and run `easyeffects -l MacBook-Warm-Smooth-Balanced-Bass`, then `easyeffects -b 2`. No automatic login startup has been configured.

## Persistent startup — 2026-10-14

Enabled a user XDG login autostart entry using `audio/enable-login-startup.sh` and `audio/start-speaker-effects.sh`. It starts EasyEffects service mode and restores the approved preset with processing enabled when an analog speaker port is active; otherwise it bypasses processing. The check is made at startup only; later headphone switching is not handled by this script. Install the preset in the output directory first.

Manual startup path passed: CLI reports Balanced Bass and bypass disabled, with physical speaker routing through effects. Next-login startup remains untested. Remove `~/.config/autostart/macbook-speaker-effects.desktop` to disable automatic launch. This supersedes earlier notes saying startup was not configured.

Reboot check found old preset/bypass restored despite startup. Startup now waits for the physical device and retries/validates the approved preset, using JSON sink inspection. Corrected manual execution passed; next-login behavior of this correction remains pending.

## Disable charger sounds — 2026-10-16

Run `audio/disable-power-sounds.sh` as the desktop user. Installs a user-local `quiet-power` sound theme inheriting freedesktop, with `power-plug.disabled` and `power-unplug.disabled` markers. GNOME sound theme saved as quiet-power; general event sounds remain enabled. This targets power connection/disconnection events only and does not alter charging or battery behavior.

Both events tested explicitly with libcanberra: returned `Sound disabled`. Saved preference persists after login/reboot; physical cable transition not performed. Restore default with `gsettings set org.gnome.desktop.sound theme-name freedesktop`.
