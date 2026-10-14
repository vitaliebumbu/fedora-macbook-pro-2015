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
