# Changelog

## 2026-10-13

- Consolidated existing MacBook keyboard, camera source, lid policy, fan settings, and Bluetooth configuration into one public setup repository.
- Backed up the recorded GNOME screenshot shortcuts and added a restore script that saves prior bindings.
- Recorded Fedora 44 DNF tuning: ten parallel downloads, default yes, no keepcache change.
- Recorded successful system update, RPM Fusion free/nonfree enablement, FFmpeg replacement, multimedia codecs, and AppStream metadata installation.
- Added Firefox session restore preference.
- Moved the 15-second Bluetooth wait off the boot target using a timer and service drop-in; reduced normal GRUB timeout to one second.
- Preserved the local FaceTime HD frozen-frame patches, upstream licenses, and contributor attribution; excluded proprietary firmware and compiled modules.
- Updated camera sleep service copy to match the installed unload-before-sleep/reload-after-wake service.
- Removed the firmware extractor's TLS verification bypass in the published source and added an explicit kernel rebuild script. These repository changes have not been installed or build-tested on the workstation.

### Verification status

DNF transactions completed successfully; repository state, Fn parameter (`1`), GNOME shortcut values, active fan service, installed lid policy, systemd syntax, and GRUB syntax were checked. New boot timing, physical shortcut actions, lid suspend/resume, media playback, and Firefox session restoration remain untested in this consolidation.

Camera installation is not currently confirmed: publication-time checks found no installed `facetimehd` module and no video device. Rebuild and stream-test before reporting it working. Earlier local camera/lid notes described Fedora 43 tests; those claims are not promoted to current Fedora 44 verification.

### Command shortcuts

- Enabled Apple keyboard Command/Control swap live and in a separate modprobe configuration; rebuilt the running kernel initramfs.
- Added Control-modifier screenshot bindings to preserve physical Command screenshot combinations.
- Recorded Command+C/V for normal apps, Command+P for print, terminal Shift requirements, Super-key side effects, and rollback.
- Runtime configuration was checked; physical application behavior and reboot persistence remain pending tests.

### Vitals panel widget

- Documented the existing Vitals v85 installation, enabled and active on GNOME Shell 50.5.
- Backed up processor-temperature panel selection, left panel position, disabled public-IP lookup, and menu positioning.
- Added a preference restore script with a prior-settings backup and installation/rollback guide.
- No live extension settings were changed during this backup; restore script syntax was checked without applying it.

### Camera repair and performance diagnostics

- Installed DKMS and PowerTOP, including matched kernel headers and package dependencies.
- Built the patched FaceTime HD driver through DKMS for kernel 7.2.10-200.fc44.x86_64; 60-frame camera stream passed at about 30 fps.
- Added DKMS registration source/configuration and documented automatic rebuild hooks and future-kernel verification limits.
- Confirmed Intel i965 H.264 acceleration availability; Firefox application-level acceleration remains a manual check.
- Recorded active-workload battery readings and prepared idle-power and suspend test procedures; no auto-tune, power-profile, fan-curve, or suspend-policy changes applied.

### Limited-storage housekeeping

- Confirmed camera capture wrote to /dev/null and saved no video.
- Added journal storage limits, weekly system/user DNF cache cleanup timers, and 30-day stale thumbnail cleanup; enabled GNOME old temporary-file cleanup.
- Retained existing daily temporary-directory cleanup and weekly SSD TRIM.
- Immediate DNF cleanup reclaimed approximately 380 MiB with no reported errors; did not remove personal files, application runtimes, browser sessions, or packages.

### Firefox playback verification

- Identified YouTube AV1 software decoding on Haswell.
- Confirmed H.264 test format and observed Firefox RDD loading Intel i965 and opening the GPU render device across four samples.
- Retained current Firefox preferences; no video saved to disk.

### YouTube codec preference

- User installed enhanced-h264ify v2.2.1; Firefox reports extension active.
- Documented codec/frame-rate tradeoffs and rollback. Same-video H.264 confirmation and thermal comparison remain pending.
