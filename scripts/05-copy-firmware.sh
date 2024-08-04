#!/bin/bash

sudo mkdir -p mnt/lib/firmware
sudo cp -ax ~/.local/var/pmbootstrap/chroot_rootfs_oneplus-fajita/boot/* mnt/boot/
sudo cp -ax ~/.local/var/pmbootstrap/chroot_rootfs_oneplus-fajita/lib/modules/* mnt/lib/modules/
sudo cp -ax ~/.local/var/pmbootstrap/chroot_rootfs_oneplus-fajita/lib/firmware/* mnt/lib/firmware/



## Copy boot image
cp mnt/boot/boot.img boot.img

## Copy firmware, kernel modules, etc

img2simg oneplus-fajita-fedora.{img,simg}
sudo sync
mv oneplus-fajita-fedora.{simg,img}


