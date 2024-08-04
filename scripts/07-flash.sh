#!/bin/sh

# NOTE: These were commented out before
sudo fastboot erase --slot=all system
sudo fastboot erase userdata
sudo fastboot erase --slot=all boot


sudo fastboot erase dtbo
sudo fastboot flash boot --slot=all boot.img
sudo fastboot flash userdata oneplus-fajita-fedora.img