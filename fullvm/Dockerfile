FROM ubuntu AS bootstrap

RUN apt-get update && \
    apt-get install -y --no-install-recommends arch-install-scripts debootstrap

RUN mkdir ubuntu:jammy

RUN debootstrap --variant=minbase jammy ubuntu:jammy  http://archive.ubuntu.com/ubuntu

FROM scratch

COPY --from=bootstrap /ubuntu:jammy /

RUN apt-get update && \
    apt-get install -y --no-install-recommends cloud-init openssh-server curl linux-modules-5.15.0-1004-kvm initramfs-tools binutils lsb-release locales libpam-systemd less

RUN echo 'fs-virtiofs' >> /etc/initramfs-tools/modules
RUN update-initramfs -c -k all

RUN curl -O https://raw.githubusercontent.com/torvalds/linux/master/scripts/extract-vmlinux
RUN chmod +x extract-vmlinux
RUN ./extract-vmlinux /boot/vmlinuz > /boot/vmlinuz-5.15.0-1004-kvm.elf
RUN mv /boot/vmlinuz-5.15.0-1004-kvm.elf /boot/vmlinuz-5.15.0-1004-kvm
RUN rm /extract-vmlinux

RUN apt remove -y binutils && apt autoremove -y
# Normally we'd do this in one RUN with all installs, but it doesn't matter since we will flatten the image anyway
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
