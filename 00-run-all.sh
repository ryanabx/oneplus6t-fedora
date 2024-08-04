#!/bin/bash

source ./scripts/01-postmarketos-stuff.sh
source ./scripts/02-clean-env.sh
source ./scripts/03-create-and-mount-image.sh
source ./scripts/04-podman-build.sh
source ./scripts/05-final-steps.sh

## Flash and reboot
sudo fastboot flash userdata oneplus-fajita-fedora.simg && sudo fastboot reboot