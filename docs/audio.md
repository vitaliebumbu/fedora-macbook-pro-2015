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
