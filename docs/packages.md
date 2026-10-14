# DNF, RPM Fusion, and multimedia codecs

## DNF settings

Merge these into the existing `[main]` section of `/etc/dnf/dnf.conf`; avoid overwriting unrelated settings:

```ini
max_parallel_downloads=10
defaultyes=True
```

Downloads run up to ten at a time. Enter accepts a confirmation prompt; prompts are not skipped automatically. `keepcache` was deliberately not enabled.

## System update

```bash
sudo dnf update
```

The recorded update installed kernel `7.2.10-200.fc44` and updated Firefox to `158.0-1.fc44`, curl, kernel tools, and related packages. Those versions are historical, not pinned requirements.

## RPM Fusion free and nonfree

```bash
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf repolist --all
```

Confirm the Fedora release repositories and their updates are enabled. This workstation's Fedora 44 free/nonfree repositories were correct; no Rawhide repair was needed. Do not apply the guide's repair commands unless your actual repository state requires them.

## Codecs

```bash
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
sudo dnf group upgrade multimedia
sudo dnf group upgrade core
```

Review the proposed removals before accepting `--allowerasing` on another setup. Here it replaced Fedora's FFmpeg libraries with full RPM Fusion FFmpeg, added GStreamer plugins, HEIF/HEVC and VVC libraries, aptX Bluetooth audio support, and software-center AppStream metadata.

The recorded transactions completed successfully. Actual media playback, aptX device negotiation, and software-center discovery were not tested. Restart applications or reboot after the library replacement.

No Terra repository, proprietary GPU driver, firmware update, or Docker installation was performed as part of these steps.
