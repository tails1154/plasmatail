#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
WORKDIR=$(pwd)
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
cp busybox/busybox plasmatail_build/bin/sh
cp busybox/busybox plasmatail_build/bin/bash
echo "Installing busybox"
plasmatail_build/bin/busybox --install -s plasmatail_build
echo "Copying tailsinit shell init thing"
cp tailsinit/init plasmatail_build/bin/init
