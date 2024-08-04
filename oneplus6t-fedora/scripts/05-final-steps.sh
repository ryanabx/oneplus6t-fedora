
## Copy firmware, kernel modules, etc
sudo mkdir -p mnt/lib/firmware
sudo cp -ax ~/.local/var/pmbootstrap/chroot_rootfs_oneplus-enchilada/boot/* mnt/boot/
sudo cp -ax ~/.local/var/pmbootstrap/chroot_rootfs_oneplus-enchilada/lib/modules/* mnt/lib/modules/
sudo cp -ax ~/.local/var/pmbootstrap/chroot_rootfs_oneplus-enchilada/lib/firmware/* mnt/lib/firmware/

## Unmount image/loop
sudo umount -R mnt
sudo losetup -d "${DEV_IMG}"

## Create flashable image
img2simg oneplus-enchilada-fedora.img oneplus-enchilada-fedora.simg

## Flash and reboot
sudo fastboot flash userdata oneplus-enchilada-fedora.simg && sudo fastboot reboot