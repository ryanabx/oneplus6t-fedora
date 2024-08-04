#!/bin/bash

sudo umount -R mnt/boot
sudo umount -R mnt
export IMG_PATH="${PWD}/oneplus-fajita-fedora.img"
sudo rm -rf "${IMG_PATH}"
sudo rm -rf ./oneplus-fajita-fedora.img
sudo rm -rf ./initramfs
sudo rm -rf ./initramfs-extra
sudo rm -rf ./mnt
for i in $(podman ps -a | grep "fedora-aarch64-device.c" | cut -d " " -f 1);do podman rm ${i};done