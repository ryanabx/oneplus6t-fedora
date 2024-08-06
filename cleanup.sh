
export PMOS_MOUNT_DIR="${PWD}/pmos-mnt"
export PMOS_IMG_PATH="${PWD}/pmos-oneplus.img"

export MOUNT_DIR="${PWD}/mnt"
export IMG_PATH="${PWD}/pmos-fedora-hybrid.img"
export SIMG_PATH="${IMG_PATH}.simg"

sudo umount -R $PMOS_MOUNT_DIR
sudo losetup -d /dev/loop0
sudo rm -rf $PMOS_MOUNT_DIR
sudo rm -rf $PMOS_IMG_PATH

# CLEANUP BEFORE ACTUAL IMAGE
sudo umount -R $MOUNT_DIR
sudo losetup -d /dev/loop1
sudo rm -rf $MOUNT_DIR
sudo rm -rf $IMG_PATH
sudo rm -rf $SIMG_PATH

for i in $(podman ps -a | grep "fedora-aarch64-device.c" | cut -d " " -f 1);do podman rm ${i};done