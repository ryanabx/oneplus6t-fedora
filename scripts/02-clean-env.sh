#!/bin/bash

sudo umount -R mnt
export IMG_PATH="${PWD}/oneplus-fajita-fedora.img"
rm -rf "${IMG_PATH}"
rm -rf oneplus-fajita-fedora.simg
rm -rf initramfs
rm -rf initramfs-extra
rm -rf mnt
for i in $(podman ps -a | grep "fedora-aarch64-device.c" | cut -d " " -f 1);do podman rm ${i};done