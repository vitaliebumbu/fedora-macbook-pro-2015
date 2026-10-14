#!/usr/bin/env bash
# Build for an explicitly selected installed kernel; does not reload the camera.
set -euo pipefail
[[ $EUID == 0 ]] || { echo "Use sudo bash $0 KERNEL_RELEASE" >&2; exit 1; }
kernel_release=${1:?Pass the full target kernel release, for example the output of uname -r}
[[ $kernel_release =~ ^[a-zA-Z0-9._+-]+$ ]] || exit 1
src=$(cd -- "$(dirname -- "$0")" && pwd)
dnf install -y "kernel-devel-$kernel_release" gcc make
make -C "$src/driver" KERNELRELEASE="$kernel_release" clean
make -C "$src/driver" KERNELRELEASE="$kernel_release"
make -C "$src/driver" KERNELRELEASE="$kernel_release" install
depmod -a "$kernel_release"
modinfo -k "$kernel_release" facetimehd
