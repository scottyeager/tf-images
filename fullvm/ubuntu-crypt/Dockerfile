FROM ubuntu AS bootstrap

RUN apt-get update && \
    apt-get install -y --no-install-recommends debootstrap

RUN mkdir rootfs

RUN debootstrap --variant=minbase jammy rootfs http://archive.ubuntu.com/ubuntu

FROM scratch AS image

COPY --from=bootstrap /rootfs /
COPY --from=ubuntu:jammy /etc/apt/sources.list /etc/apt/

# Use generic kernel this time, since kvm doesn't have dm-crypt
ARG KERNEL=5.19.0-50-generic

RUN <<EOF 
DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y --no-install-recommends cloud-init openssh-server curl linux-modules-${KERNEL} linux-image-${KERNEL} initramfs-tools binutils lsb-release locales libpam-systemd less overlayroot


echo 'fs-virtiofs' >> /etc/initramfs-tools/modules
update-initramfs -c -k all

curl -O https://raw.githubusercontent.com/torvalds/linux/master/scripts/extract-vmlinux
chmod +x extract-vmlinux
./extract-vmlinux /boot/vmlinuz > /boot/vmlinuz-${KERNEL}.elf
mv /boot/vmlinuz-${KERNEL}.elf /boot/vmlinuz-${KERNEL}
rm /extract-vmlinux

apt remove -y binutils && apt autoremove -y
apt-get clean && \
    rm -rf /var/lib/apt/lists/*
EOF

COPY ./overlayroot.conf /etc/

FROM ubuntu AS touchup

RUN mkdir rootfs
COPY --from=image / /rootfs
RUN rm rootfs/etc/resolv.conf
RUN ln -s /run/systemd/resolve/resolv.conf rootfs/etc/resolv.conf
RUN cat <<EOF > rootfs/etc/hosts
127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

RUN tar czf img.tar.gz -C rootfs .

FROM scratch AS archive

COPY --from=touchup /img.tar.gz /
