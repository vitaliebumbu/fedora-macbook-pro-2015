# Accelerated local video playback

Installed mpv 0.41.0 from Fedora, with its dependencies (about 39 MiB installed). A repository metadata refresh stalled; installation succeeded using downloaded metadata from Fedora and RPM Fusion Free without changing persistent repository enablement.

Merge `mpv/mpv.conf` into `~/.config/mpv/mpv.conf`:

```ini
hwdec=auto
```

Open mpv from the application menu, drag a video into its window, or run `mpv /path/to/video.mp4`. Hardware decoding is selected for supported codecs; unsupported formats fall back to software. Haswell supports H.264, but not AV1/VP9/HEVC hardware decoding. No file associations were changed.

A temporary local H.264 sample passed a three-second muted playback test using the GPU renderer and X11 EGL context. mpv explicitly reported `Using hardware decoding (vaapi)` and exited successfully. The sample was removed afterward. This does not benchmark all resolutions or verify audio/video sync in long media.

The iHD probe failed before successful legacy Intel decoding fallback; optional CUDA/hybrid-driver messages did not stop playback. To troubleshoot visual problems, use `mpv --hwdec=no FILE`. Remove the added `hwdec=auto` line to return to prior decoder defaults.

Reference: [mpv hardware-decoding documentation](https://mpv.io/manual/stable/#options-hwdec).

A second playback using the saved configuration and default gpu-next renderer also reported VA-API hardware decoding and exited successfully. It streamed the small sample without saving another file.
