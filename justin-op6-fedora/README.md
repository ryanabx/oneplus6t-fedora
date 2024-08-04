# Fedora on OnePlus 6

- All steps done on Fedora 38
- Still a Work in Progress

Disclaimer: Use this at your own risk

# Prepare postmarketOS Boot Image
## Install pmbootstrap and get an image ready, this is just for the boot image for now
```
sudo dnf install -y pmbootstrap
pmbootstrap init
```
Settings: Edge, oneplus, enchilada, enable firmware, interface none
```
pmbootstrap install
```

# Build UserData Image
## Ensure environment is clean
```
sudo umount -R mnt
export IMG_PATH="${PWD}/oneplus-enchilada-fedora.img"
rm -rf "${IMG_PATH}"
rm -rf oneplus-enchilada-fedora.simg
rm -rf initramfs
rm -rf initramfs-extra
rm -rf mnt
```

## Clean up podman containers
```
for i in $(podman ps -a | grep "fedora-aarch64-device.c" | cut -d " " -f 1);do podman rm ${i};done
```

## Create empty 5GB image for the userdata
```
truncate -s 5G "${IMG_PATH}"
```

## Setup loop device to mount image
```
export DEV_IMG="$(sudo losetup -P -f "${IMG_PATH}" -b 4096 --show)"
```

## Create partitions on the image to mirror what postmarketOS does
```
sudo parted -s "${DEV_IMG}" mktable msdos
sudo parted -s "${DEV_IMG}" mkpart primary ext2 2048s 256M
sudo parted -s "${DEV_IMG}" mkpart primary 256M 100%
sudo parted -s "${DEV_IMG}" set 1 boot on
export DEV_BOOT="${DEV_IMG}p1"
export DEV_ROOT="${DEV_IMG}p2"
```

## Create filesystems
```
sudo mkfs.ext4 -O ^metadata_csum -F -q -L pmOS_root -N 100000 "${DEV_ROOT}"
sudo mkfs.ext2 -F -q -L pmOS_boot "${DEV_BOOT}"
```

## Mount Partitions
```
mkdir -p mnt
sudo mount "${DEV_ROOT}" mnt
sudo mkdir -p mnt/boot
sudo mount "${DEV_BOOT}" mnt/boot
```

## Podman Stuff to prepare Fedora userdata fs contents
```
podman image build --arch aarch64 -t "fedora-aarch64-device.i" -f Containerfile
```
## Run this once to generate the container:
```
podman run --arch aarch64 -it --name "fedora-aarch64-device.c" localhost/"fedora-aarch64-device.i":latest
```
## Export container filesystem to mnt directory
```
podman export fedora-aarch64-device.c | sudo tar -C mnt/ -xp
```

## Copy firmware, kernel modules, etc
```
sudo mkdir -p mnt/lib/firmware
sudo cp -ax ~/.local/var/pmbootstrap/chroot_rootfs_oneplus-enchilada/boot/* mnt/boot/
sudo cp -ax ~/.local/var/pmbootstrap/chroot_rootfs_oneplus-enchilada/lib/modules/* mnt/lib/modules/
sudo cp -ax ~/.local/var/pmbootstrap/chroot_rootfs_oneplus-enchilada/lib/firmware/* mnt/lib/firmware/
```

## Unmount image/loop
```
sudo umount -R mnt
sudo losetup -d "${DEV_IMG}"
```

## Create flashable image
```
img2simg oneplus-enchilada-fedora.img oneplus-enchilada-fedora.simg
```

## Flash and reboot
```
sudo fastboot flash userdata oneplus-enchilada-fedora.simg && sudo fastboot reboot
```

# On Device Setup

## Set Date/Time as it starts at UNIX epoch
```
sudo timedatectl set-time 'YYYY-MM-DD HH:MM:SS'
```
Note: An easy way to get this from your computer is by running `date '+%Y-%m-%d %H:%M:%S'`