#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

WORKDIR=$(pwd)
DISK="disk.img"
MNT="$WORKDIR/mnt"
LOOP=""

cleanup() {
    echo "[CLEANUP] Running cleanup..."
    set +e
    if mountpoint -q "$MNT"; then
        sudo umount "$MNT"
    fi
    if [[ -n "$LOOP" ]] && losetup "$LOOP" &>/dev/null; then
        sudo losetup -d "$LOOP"
    fi
    rm -rf "$MNT"
}
trap cleanup EXIT

echo "[1] Reset build directory"
rm -rf plasmatail_build
mkdir -p plasmatail_build/{bin,boot,dev,etc,home,lib,lib64,media,mnt,opt,proc,run,sbin,sys,tmp,usr,var,sbin}

echo "[2] Build kernel"
cd kernel
make -j"$(nproc)"
cd "$WORKDIR"
cp kernel/arch/x86/boot/bzImage plasmatail_build/boot/vmlinuz

echo "[3] Install BusyBox"
cp busybox/busybox plasmatail_build/bin/
plasmatail_build/bin/busybox --install -s plasmatail_build/bin

echo "[4] Install init"
cp tailsinit/init plasmatail_build/sbin/init
chmod +x plasmatail_build/sbin/init

mkdir -p $WORKDIR/plasmatail_build/boot/grub
echo "[4.5] Write grub.cfg"
sudo tee "$WORKDIR/plasmatail_build/boot/grub/grub.cfg" >/dev/null <<EOF
set default=0
set timeout=0

menuentry "PlasmaTail Linux" {
    linux /boot/vmlinuz root=/dev/sda1 rw console=tty0
}
EOF

echo "[5] Create disk image"
rm -f "$DISK"
dd if=/dev/zero of="$DISK" bs=1M count=512 status=progress

echo "[6] Partition disk (MBR)"
parted "$DISK" --script mklabel msdos
parted "$DISK" --script mkpart primary ext4 1MiB 100%
parted "$DISK" --script set 1 boot on

echo "[7] Attach loop device"
LOOP=$(sudo losetup --show -Pf "$DISK")
echo " -> Loop device: $LOOP"

echo "[8] Create filesystem"
sudo mkfs.ext4 "${LOOP}p1"

echo "[9] Mount partition"
mkdir -p "$MNT"
sudo mount "${LOOP}p1" "$MNT"

echo "[10] Copy rootfs"
sudo cp -a plasmatail_build/* "$MNT/"

echo "[11] Install GRUB"
sudo grub-install \
  --target=i386-pc \
  --boot-directory="$MNT/boot" \
  "$LOOP"


echo "[13] Boot QEMU"
qemu-system-x86_64 \
    -m 512M \
    -hda "$DISK" \
    -vga std
