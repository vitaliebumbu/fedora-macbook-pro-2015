# FaceTime HD camera

The Broadcom PCIe FaceTime HD camera requires an out-of-tree driver and extracted Apple firmware. This repository preserves the locally patched source and upstream attribution under `camera/`.

## Patch history

See [camera/CHANGES.md](../camera/CHANGES.md) for the existing frozen-frame patch: asynchronous buffer submission, monotonic timestamps and sequence numbers, and correction of an IRQ-loop variable. These are inherited source changes, not new driver changes in this consolidation.

## Install from a full checkout

Inspect the installer and extractor before running them. Installation downloads Apple camera update data, extracts firmware locally, builds against the running kernel, installs the driver, blacklists `bdc_pci`, enables loading on boot, and installs the camera sleep service.

```bash
sudo bash camera/install.sh
```

Apple firmware and compiled modules are intentionally excluded from Git. The extractor's download command was adjusted to retain TLS certificate verification in this consolidation.

## Kernel upgrades

The original installer is a manual build. The optional DKMS registration below adds automatic rebuilds. Build again for each target kernel before relying on the camera:

```bash
rpm -q kernel-core --qf '%{VERSION}-%{RELEASE}.%{ARCH}\n'
sudo bash camera/rebuild-for-kernel.sh TARGET_KERNEL_RELEASE
```

Use the exact release shown by RPM. To rebuild for the running kernel, use `sudo bash camera/rebuild-for-kernel.sh "$(uname -r)"`. The rebuild script does not load or unload the running module.

If Secure Boot is enabled, unsigned out-of-tree modules may require signing and key enrollment. Do not disable Secure Boot as an automatic installation step.

## Verify

```bash
modinfo facetimehd
sudo modprobe facetimehd
ls /dev/video*
sudo dnf install v4l-utils
v4l2-ctl --list-devices
# Choose the correct device from the list above:
timeout 15 v4l2-ctl --device=/dev/video0 --stream-mmap --stream-count=60 --stream-to=/dev/null
```

A device node alone does not demonstrate a working stream. Check frame progress and test your intended application. Before suspend, close applications using the camera so unloading can succeed.

## Publication-time status

The check on 2026-10-13 found source and configuration, but `modinfo facetimehd` failed and no `/dev/video*` node was listed. A check for the newly installed `7.2.10-200.fc44.x86_64` module also failed. Camera operation is therefore **pending rebuild and testing**, rather than confirmed working.

For removal, inspect `camera/uninstall.sh` before running it; it removes driver configuration and firmware. Keep backups of your prior configuration.

## DKMS automatic rebuilds — verified 2026-10-13

The patched source was registered as `facetimehd/0.6.13-workstation1` and built for `7.2.10-200.fc44.x86_64`. The camera passed a 60-frame V4L2 capture at about 30 fps. This supersedes the missing-module publication snapshot above.

After firmware installation, register it on another machine:

```bash
sudo bash camera/install-dkms.sh
sudo dkms status
```

Fedora's installed DKMS package provides `/usr/lib/kernel/install.d/40-dkms.install`; `AUTOINSTALL=yes` enables rebuilding for subsequent kernels when matching headers are available. Future-kernel builds are not yet tested. The deprecated CLEAN setting may produce a warning on current DKMS.

DKMS generated a local module-signing key. If Secure Boot requires enrollment, follow the distribution's enrollment procedure; the signing key must never be published. This workstation loaded the module successfully.

Do not rerun the manual installer over a DKMS-managed module. After kernel updates, inspect DKMS status and test streaming before assuming camera availability. To remove this registration: `sudo dkms remove -m facetimehd -v 0.6.13-workstation1 --all`; remove the corresponding `/usr/src/` directory only after confirming it is no longer needed.
