FROM registry.fedoraproject.org/fedora:latest

RUN dnf upgrade -y --refresh && dnf install -y dnf5 dnf5-plugins

# Create fstab
RUN echo "/dev/mapper/sda17p2  /         btrfs  rw,relatime,subvol=/fedora  0 0" >> /etc/fstab && \
    echo "/dev/mapper/sda17p1  /boot     ext2   rw,relatime                 0 0" >> /etc/fstab && \
    echo "/dev/mapper/sda17p2  /pmos     btrfs  rw,relatime,subvol=/pmos    0 0" >> /etc/fstab && \
    echo "/dev/mapper/sda17p2  /sda17p2  btrfs  rw,relatime,subvolid=5      0 0" >> /etc/fstab

# ============================================== #

RUN dnf upgrade -y --refresh
RUN dnf install -y dnf5 dnf5-plugins

RUN dnf5 install -y \
  systemd \
  systemd-udev

# RUN dnf5 install -y openssh-server && \
#   systemctl enable sshd

RUN dnf5 install -y \
  'dnf-command(copr)' \
  tmux vim \
  btrfs-progs \
  iproute NetworkManager-tui NetworkManager-wifi wpa_supplicant

RUN dnf5 remove -y 'plymouth*' && \
    dnf5 install -y rmtfs pd-mapper

RUN dnf copr enable -y ryanabx/op6 && \
    dnf5 install -y qbootctl

RUN systemctl enable pd-mapper && \
    systemctl enable qbootctl-mark-boot-successful.service && \
    systemctl enable rmtfs

RUN install -d -o 0 -g 0 -m 0755 /sda17p2

COPY resources/pmos-adopt-and-integrate /usr/bin/pmos-adopt-and-integrate
COPY resources/pmos-chroot-adv /usr/bin/pmos-chroot-adv
COPY resources/update-all /usr/local/bin/update-all

RUN echo 'root:654321' | chpasswd 

RUN groupadd -g 1000 unpriv && \
  useradd -g 1000 -G wheel -m -u 1000 unpriv && \
  echo 'unpriv:123456' | chpasswd

CMD ["/bin/bash", "-l", "-i"]