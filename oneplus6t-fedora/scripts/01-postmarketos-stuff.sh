#!/bin/bash

# Disclaimer: Use this at your own risk

# Prepare postmarketOS Boot Image
## Install pmbootstrap and get an image ready, this is just for the boot image for now
sudo dnf install -y pmbootstrap
pmbootstrap init
# Settings: Edge, oneplus, enchilada, enable firmware, interface none
pmbootstrap install