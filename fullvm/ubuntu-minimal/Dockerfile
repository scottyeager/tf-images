FROM ubuntu AS bootstrap

RUN apt-get update && \
    apt-get install -y --no-install-recommends debootstrap

RUN mkdir rootfs

RUN debootstrap --variant=minbase jammy rootfs http://archive.ubuntu.com/ubuntu

FROM scratch

COPY --from=bootstrap /rootfs /
COPY --from=ubuntu:jammy /etc/apt/sources.list /etc/apt/

ARG KERNEL=5.15.0-1004-kvm

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y --no-install-recommends cloud-init openssh-server curl linux-modules-${KERNEL} initramfs-tools binutils lsb-release locales libpam-systemd less


RUN echo 'fs-virtiofs' >> /etc/initramfs-tools/modules
RUN update-initramfs -c -k all

RUN curl -O https://raw.githubusercontent.com/torvalds/linux/master/scripts/extract-vmlinux
RUN chmod +x extract-vmlinux
RUN ./extract-vmlinux /boot/vmlinuz > /boot/vmlinuz-${KERNEL}.elf
RUN mv /boot/vmlinuz-${KERNEL}.elf /boot/vmlinuz-${KERNEL}
RUN rm /extract-vmlinux

RUN apt remove -y binutils && apt autoremove -y
# Normally we'd do this in one RUN with all installs, but it doesn't matter since we will flatten the image anyway
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*
