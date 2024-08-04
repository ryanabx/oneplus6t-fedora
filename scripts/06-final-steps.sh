#!/bin/bash

sudo umount mnt/boot
sudo umount mnt
sudo sync
sudo losetup -d "${DEV_IMG}"
sudo sync