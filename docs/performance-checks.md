# Performance, video, battery, and suspend checks

## Video acceleration

`vainfo` detected the Intel i965 Haswell driver with H.264 decode and encode profiles. Initial iHD probing failed before successful i965 fallback; installing a newer Intel media driver is not the appropriate solution for Haswell.

Check Firefox `about:support`: Compositing should report hardware WebRender, and HARDWARE_VIDEO_DECODING should be available. Test an H.264 clip and compare CPU use; driver availability alone does not prove Firefox uses it. Firefox's live support page was not inspected in this session. No browser decoding preferences were forced.

Haswell lacks hardware VP9/AV1 decoding. Selecting H.264 for compatible video services can reduce software decoding load, with resolution/quality tradeoffs. See [Fedora guidance](https://fedoraproject.org/wiki/Firefox_Hardware_acceleration) and [Intel codec support](https://github.com/intel/intel-vaapi-driver/blob/master/README).

## Power baseline

Installed PowerTOP for diagnostics; no auto-tune, calibration, or persistent tunables were applied. Existing TuneD balanced-battery, thermald, and mbpfan were retained. SSD TRIM was already enabled.

For a meaningful idle test, disconnect AC, stop remote streaming, pause video, save work, and leave the desktop quiet for several minutes. Record brightness and connected devices. Run `sudo powertop` to inspect activity and idle states without enabling suggested tunables wholesale.

During active setup work, four battery current/voltage samples calculated 57–74 W discharge. These include active applications and setup activity, are not an idle baseline, and were not independently validated against an external power meter. Battery full/design charge ratio was approximately 80% with 196 reported cycles.

## Sleep/wake checklist

Deep sleep is selected (`s2idle [deep]`). No blocking sleep inhibitor was observed beyond normal desktop handling and delay inhibitors. Actual sleep was not triggered during the active session.

1. Save work, close camera applications, note battery percentage and time.
2. Run `systemctl suspend` locally; wake and verify screen, keyboard, Wi-Fi, Bluetooth, and audio.
3. Test lid close/open on battery and AC, then a longer battery sleep interval.
4. After wake, run `journalctl -b -u systemd-suspend.service -u facetimehd-unload.service -u systemd-logind` and repeat the camera frame capture.
5. Measure sleep battery loss over a known interval before applying ACPI wake-source changes.

Keep working lid wake behavior unless evidence identifies a specific problem. Do not copy 13-inch MacBook USB paths, force PCIe ASPM, disable security mitigations, or stack competing power managers as generic optimizations.

## Firefox playback check — 2026-10-13

YouTube Stats for nerds showed AV1 (`av01`) at 1280x720/30 fps, with 81 dropped frames out of 6538. During that playback, the Firefox RDD process had no GPU render device or Intel decoding driver open, consistent with software decoding. Haswell does not accelerate AV1.

Opened the [MDN sample video](https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4) in the running Firefox; ffprobe confirmed H.264. Across four process inspections, RDD had loaded `i965_drv_video.so` and opened `/dev/dri/renderD128`, providing evidence that the hardware-decoding path engaged for the supported codec. No Firefox settings were changed and no video was downloaded to disk. This is process-level evidence, not a GPU engine utilization benchmark.

For YouTube, selecting H.264 using a compatible codec-selection extension is an optional next step; it can reduce available resolution and requires a separate playback test. Installing a newer driver cannot add AV1 decoding hardware to this GPU.

## YouTube H.264 preference extension

Installed [enhanced-h264ify](https://addons.mozilla.org/en-US/firefox/addon/enhanced-h264ify/) v2.2.1 and confirmed Firefox reports it active. Its default codec blocking prefers H.264 and blocks 60 fps video; adjust options if that tradeoff is unwanted. It operates on YouTube-related domains.

Reload existing YouTube video tabs after installation. Stats for nerds should show `avc1` for H.264. Firefox's RDD process still had the Intel driver and GPU device open after installation, but those resources may remain from the earlier H.264 sample; this alone does not establish the new YouTube stream's codec or prove a temperature improvement. Same-video codec and power comparison remain pending.

Disable or remove the extension in `about:addons` to undo. Higher-resolution YouTube formats may become unavailable when preferring H.264.
