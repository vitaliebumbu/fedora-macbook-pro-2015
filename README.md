# Fedora on the 2015 15-inch Retina MacBook Pro

Practical setup notes, configuration backups, and hardware fixes for **Fedora Linux 44 Workstation on MacBookPro11,4** (Mid-2015, 15-inch Retina). Includes the FaceTime HD camera source, media keys without Fn, macOS-style screenshots, lid suspend, Bluetooth initialization, fan control, multimedia codecs, and reboot tuning.

These files document one workstation. Apply the sections you need after reviewing their commands and backing up your existing configuration. There is no automatic installer that changes everything at once.

## Setup guide

| Area | Configuration and instructions |
| --- | --- |
| Keyboard | [Brightness, volume, and media keys without Fn](docs/keyboard-and-screenshots.md) |
| Screenshots | [Command+Shift shortcuts](docs/keyboard-and-screenshots.md#screenshot-shortcuts) |
| Camera | [FaceTime HD driver, firmware extraction, and kernel updates](docs/camera.md) |
| Lid and sleep | [Lid-close suspend and camera sleep/wake handling](docs/suspend.md) |
| Bluetooth and reboot | [Delayed Bluetooth without blocking boot, GRUB timeout](docs/bluetooth-and-boot.md) |
| Monitoring | [Vitals temperature and system panel widget](docs/vitals.md) |
| Cooling | [Fan settings and mbpfan](docs/fans.md) |
| Packages | [DNF, RPM Fusion free/nonfree, and codecs](docs/packages.md) |
| Firefox | [Restore previous windows and tabs](docs/firefox.md) |
| Status | [Recorded changes and verification limits](CHANGELOG.md) |

## Hardware and scope

- Recorded model: **MacBookPro11,4**, Intel 15-inch Retina MacBook Pro, Mid-2015.
- Current setup: **Fedora 44 Workstation / GNOME**. Some original fix notes were recorded on Fedora 43; they are historical context, not proof of a current test.
- MacBookPro11,5 and other models have not been validated here.
- Hardware-specific fixes are optional. Do not copy USB paths, fan settings, or suspend workarounds blindly onto another model.

```bash
cat /sys/class/dmi/id/product_name
cat /etc/fedora-release
uname -r
```

## Get the files

```bash
git clone https://github.com/vitaliebumbu/fedora-macbook-pro-2015.git
cd fedora-macbook-pro-2015
```

**Current camera status needs attention:** camera source and configuration are backed up, but the publication-time check did not find an installed `facetimehd` module or `/dev/video0`. Follow the camera guide to build for your kernel and verify an actual video stream.

## Updates and contributions

Future setup changes belong in the relevant folder, its guide, and [CHANGELOG.md](CHANGELOG.md). See [CONTRIBUTING.md](CONTRIBUTING.md) for verification and publishing rules. Report your Fedora version, kernel, model, symptom, and sanitized diagnostics in issues.

No credentials, browser profiles, firmware binaries, machine identifiers, or compiled kernel modules are included. This is a reproducible setup backup, not a full disk image.

## Credits and licenses

The camera driver and extractor retain their upstream licensing and attribution: [patjak/facetimehd](https://github.com/patjak/facetimehd), [patjak/facetimehd-firmware](https://github.com/patjak/facetimehd-firmware), and [camera/NOTICE](camera/NOTICE). Keyboard scripts retain their MIT license. Cooling uses [linux-on-mac/mbpfan](https://github.com/linux-on-mac/mbpfan); only its configuration and service are included here. New documentation and configuration examples are MIT licensed; see [LICENSE](LICENSE).

The DNF and RPM Fusion steps were adapted from the [TechHut Fedora 44 post-install guide](https://techhut.tv/fedora-44-post-install-guide).
