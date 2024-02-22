#!/bin/bash

# Make a few final touches that we can't do from inside Docker.
# Takes a tar of the container image we generated in stage one
# and produces a compressed version with changes
#
# This requires root so that file ownership ends up correct, so
# we run it in a container and thus don't worry about cleanup

mkdir rootfs
tar xf ubuntu-fullvm.tar -C rootfs

# If we don't do this, systemd thinks it's booting in a Docker container
rm rootfs/.dockerenv

# Fix systemd DNS
rm rootfs/etc/resolv.conf
ln -s /run/systemd/resolve/resolv.conf rootfs/etc/resolv.conf

# Write hosts file (taken from: https://github.com/canonical/subiquity/blob/main/subiquity/models/subiquity.py)

cat << EOF > rootfs/etc/hosts
127.0.0.1 localhost

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

tar czf ubuntu-fullvm.tar.gz -C rootfs .
