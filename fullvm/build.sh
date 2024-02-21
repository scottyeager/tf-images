#!/bin/bash

docker buildx build -t ubuntu:gridfullvm .

container=$(docker create ubuntu:gridfullvm bash)
docker export $container --output=ubuntu-fullvm.tar
docker rm $container

mkdir rootfs
sudo tar xf ubuntu-fullvm.tar -C rootfs
# If we don't do this, systemd thinks it's booting in a Docker container
sudo rm rootfs/.dockerenv
# Fix systemd DNS
sudo rm rootfs/etc/resolv.conf
sudo ln -s /run/systemd/resolve/resolv.conf rootfs/etc/resolv.conf
sudo tar czf ubuntu-fullvm.tar.gz -C rootfs .
sudo rm -rf rootfs
rm ubuntu-fullvm.tar
