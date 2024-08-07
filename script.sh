#!/bin/bash

# EXPORTS AND CLEANUPS
source ./cleanup.sh

# ================================================= #
echo "PMOS IMAGE"

simg2img /tmp/postmarketOS-export/oneplus-fajita.img "${PMOS_IMG_PATH}"

export LOOP_IMG_PMOS="$(sudo losetup -P -f "${PMOS_IMG_PATH}" -b 4096 --show)"
export DEV_BOOT_PMOS="${LOOP_IMG_PMOS}p1"
export DEV_ROOT_PMOS="${LOOP_IMG_PMOS}p2"
mkdir -p $PMOS_MOUNT_DIR
sudo mount "${DEV_ROOT_PMOS}" $PMOS_MOUNT_DIR
sudo mkdir -p $PMOS_MOUNT_DIR/boot
sudo mount "${DEV_BOOT_PMOS}" $PMOS_MOUNT_DIR/boot

# ======================================== #
echo "ACTUAL IMAGE"

truncate -s 5G "${IMG_PATH}"

# EXPORT DEV_IMG
export DEV_IMG="$(sudo losetup -P -f "${IMG_PATH}" -b 4096 --show)"

# MAKE PARTITIONS
sudo parted -s "${DEV_IMG}" mktable msdos
sudo parted -s "${DEV_IMG}" mkpart primary ext2 2048s 256M
sudo parted -s "${DEV_IMG}" mkpart primary 256M 100%
sudo parted -s "${DEV_IMG}" set 1 boot on
# EXPORT VARIABLES
export DEV_BOOT="${DEV_IMG}p1"
export DEV_ROOT="${DEV_IMG}p2"
# MAKE FILESYSTEMS
sudo mkfs.ext4 -O ^metadata_csum -F -q -L pmOS_root -N 100000 "${DEV_ROOT}"
sudo mkfs.ext2 -F -q -L pmOS_boot "${DEV_BOOT}"
# MOUNT PARTITIONS
mkdir -p "${MOUNT_DIR}"
sudo mount "${DEV_ROOT}" "${MOUNT_DIR}"
sudo mkdir -p "${MOUNT_DIR}/boot"
sudo mount "${DEV_BOOT}" "${MOUNT_DIR}/boot"

# TEST
sudo cp -r "${PMOS_MOUNT_DIR}/*" "${MOUNT_DIR}/"
# RUN DOCKER
# echo "PODMAN BUILD"
# podman image build --rm --arch aarch64 -t "fedora-aarch64-device.i" -f Containerfile
# echo "PODMAN RUN"
# podman run --arch aarch64 -it --name "fedora-aarch64-device.c" localhost/"fedora-aarch64-device.i":latest
echo "PODMAN CONTAINER BUILD"
podman pull ghcr.io/ryanabx/oneplus-fedora-container:latest
podman container create --arch "aarch64" -it --name "fedora-aarch64-device.c" "ghcr.io/ryanabx/oneplus-fedora-container:latest"
echo "PODMAN EXPORT"
# FILL ROOTFS WITH DOCKER CONTAINER
podman export fedora-aarch64-device.c | sudo tar -C "${MOUNT_DIR}" -xp
echo "CONTINUE"
sudo mkdir -p mnt/lib/firmware
## pmos-adopt-and-integrate
sudo cp -ax "${PMOS_MOUNT_DIR}"/boot/ "${MOUNT_DIR}"/
sudo cp -ax "${PMOS_MOUNT_DIR}"/lib/modules/ "${MOUNT_DIR}"/lib/
sudo cp -ax "${PMOS_MOUNT_DIR}"/lib/firmware/ "${MOUNT_DIR}"/lib/
sudo cp -ax "${PMOS_MOUNT_DIR}"/usr/share/alsa/ucm2/ "${MOUNT_DIR}"/usr/share/alsa/

# UNMOUNT IMAGES
# sudo umount -R "${MOUNT_DIR}"
# sudo umount -R "${PMOS_MOUNT_DIR}"
# sudo losetup -d "${DEV_IMG}"
# sudo losetup -d "${DEV_ROOT_PMOS}"

# CREATE FLASHABLE IMAGE

img2simg "${IMG_PATH}" "${SIMG_PATH}"

echo "DONE! At ${SIMG_PATH}"