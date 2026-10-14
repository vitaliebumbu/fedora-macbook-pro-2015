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
