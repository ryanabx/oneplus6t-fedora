
## Copy firmware, kernel modules, etc
sudo mkdir -p mnt/lib/firmware
sudo cp -ax ~/.local/var/pmbootstrap/chroot_rootfs_oneplus-fajita/boot/* mnt/boot/
sudo cp -ax ~/.local/var/pmbootstrap/chroot_rootfs_oneplus-fajita/lib/modules/* mnt/lib/modules/
sudo cp -ax ~/.local/var/pmbootstrap/chroot_rootfs_oneplus-fajita/lib/firmware/* mnt/lib/firmware/

## Unmount image/loop
sudo umount -R mnt
sudo losetup -d "${DEV_IMG}"

## Create flashable image
img2simg oneplus-fajita-fedora.img oneplus-fajita-fedora.simg

## Flash and reboot
sudo fastboot flash userdata oneplus-fajita-fedora.simg && sudo fastboot reboot