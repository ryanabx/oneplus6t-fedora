#!/bin/bash

export IMG_PATH="${PWD}/oneplus-fajita-fedora.img"
rm -rf "${IMG_PATH}"
truncate -s 5G "${IMG_PATH}"


export DEV_IMG="$(sudo losetup -P -f "${IMG_PATH}" -b 4096 --show)"

sudo parted -s "${DEV_IMG}" mktable msdos
sudo parted -s "${DEV_IMG}" mkpart primary ext2 2048s 256M
sudo parted -s "${DEV_IMG}" mkpart primary 256M 100%
sudo parted -s "${DEV_IMG}" set 1 boot on

export DEV_BOOT="${DEV_IMG}p1"
export DEV_ROOT="${DEV_IMG}p2"

sudo mkfs.ext4 -O ^metadata_csum -F -q -L pmOS_root -N 100000 "${DEV_ROOT}"
sudo mkfs.ext2 -F -q -L pmOS_boot "${DEV_BOOT}"

mkdir -p mnt
sudo mount "${DEV_ROOT}" mnt
sudo mkdir -p mnt/boot
sudo mount "${DEV_BOOT}" mnt/boot
