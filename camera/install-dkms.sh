#!/usr/bin/env bash
# Register the patched source for automatic kernel rebuilds.
set -euo pipefail
[[ $EUID == 0 ]] || { echo "Run with sudo bash $0" >&2; exit 1; }
src=$(cd -- "$(dirname -- "$0")" && pwd)
version=0.6.13-workstation1
dest=/usr/src/facetimehd-$version
[[ ! -e "$dest" ]] || { echo 'Source already registered; inspect dkms status before updating.' >&2; exit 1; }
[[ -s /usr/lib/firmware/facetimehd/firmware.bin ]] || { echo 'Install camera firmware using camera/install.sh first.' >&2; exit 1; }
dnf install -y dkms gcc make "kernel-devel-$(uname -r)"
cp -a "$src/driver" "$dest"
cp "$src/dkms-workstation.conf" "$dest/dkms.conf"
dkms add -m facetimehd -v "$version"
dkms install -m facetimehd -v "$version" -k "$(uname -r)"
modprobe facetimehd
dkms status
