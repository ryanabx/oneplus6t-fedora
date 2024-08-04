#!/bin/bash

sudo umount -R mnt
export IMG_PATH="${PWD}/oneplus-enchilada-fedora.img"
rm -rf "${IMG_PATH}"
rm -rf oneplus-enchilada-fedora.simg
rm -rf initramfs
rm -rf initramfs-extra
rm -rf mnt
for i in $(podman ps -a | grep "fedora-aarch64-device.c" | cut -d " " -f 1);do podman rm ${i};done