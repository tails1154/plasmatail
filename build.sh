#!/bin/bash





set -euo pipefail
IFS=$'\n\t'
WORKDIR=$(pwd)



startqemu() {
	cd $WORKDIR
	dd if=/dev/zero of=rootfs.img bs=1M count=256
	mkfs.ext4 rootfs.img
	sudo mount rootfs.img /mnt
	sudo cp -a plasmatail_build/* /mnt/
	sudo umount /mnt
	qemu-system-x86_64 \
	  -kernel plasmatail_build/boot/vmlinuz \
	  -drive file=rootfs.img,format=raw \
	  -append "root=/dev/sda rw console=ttyS0 init=/init" \

}








echo "Tails1154 Linux Builder"
echo "Removing existing work dir"
rm -rf plasmatail_build
echo "Creating new dir"
mkdir plasmatail_build
echo "Creating linux dirs"
mkdir -p plasmatail_build/{bin,boot,dev,etc,home,lib,lib64,media,mnt,opt,proc}
echo "Building kernel"
cd kernel
make -j$(nproc)
echo "Copying kernel"
cp arch/x86/boot/bzImage ../plasmatail_build/boot/vmlinuz
cd $WORKDIR
echo "Copying busybox"
cp busybox/busybox plasmatail_build/bin/
echo "Installing busybox"
plasmatail_build/bin/busybox --install -s plasmatail_build/bin
echo "Copying tailsinit shell init thing"
cp tailsinit/init plasmatail_build/init
echo "Starting qemu"
startqemu
