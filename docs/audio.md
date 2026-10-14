# Built-in speaker audio

The MacBook uses the Cirrus CS4208 analog stereo speaker output through PipeWire/WirePlumber. Speaker channels were active and no software effects were present at the start of investigation.

On 2026-10-14 EasyEffects 8.2.8 and its plugins were installed. A conservative EQ trial was loaded and stereo routing verified. The user preferred the previous sound, so the trial was bypassed and EasyEffects quit. Final routing was verified directly from Firefox to the physical stereo speaker output. No EasyEffects autostart, output-volume increase, or persistent EQ startup was configured. The experiment was not accepted as a sound-quality improvement.

The inactive trial remains locally available but is not the recommended default. Any further tuning should start with listening feedback and a level-matched bypass comparison; software processing cannot establish acoustic quality without listening or measurement.

An initial release-only package installation selected older Qt and multimedia packages. These were immediately upgraded from the updates repository. Final verified versions include Qt6 base 6.11.2, GStreamer good 1.28.8, and mediawriter 5.3.2. Use all current Fedora repositories when installing EasyEffects; do not reproduce the release-only installation.

EasyEffects can be launched from the application menu if manual experimentation is wanted. Its bypass and quit controls restore direct playback. Do not automatically apply speaker tuning to headphones.
