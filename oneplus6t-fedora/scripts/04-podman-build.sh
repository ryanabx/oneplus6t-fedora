## Podman Stuff to prepare Fedora userdata fs contents
podman image build --arch aarch64 -t "fedora-aarch64-device.i" -f Containerfile
## Run this once to generate the container:
podman run --arch aarch64 -it --name "fedora-aarch64-device.c" localhost/"fedora-aarch64-device.i":latest
## Export container filesystem to mnt directory
podman export fedora-aarch64-device.c | sudo tar -C mnt/ -xp