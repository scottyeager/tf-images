#!/bin/bash

# Makes a qcow2 image from a tar archive
# Also copies kernel and initrd to pwd
# Takes one argument: path to archive

dd if=/dev/null of=tmp.img bs=1M seek=512
mkfs.ext3 tmp.img
tmp_mnt=$(mktmp -d)
sudo mount -t ext3 -o loop tmp.img mnt
sudo tar xf $1 -C $tmp_mnt 
cp $tmp_mnt/boot/initrd.img ./
cp $tmp_mnt/boot/vmlinuz ./
sudo umount $tmp_mnt
qemu-img convert -O qcow2 tmp.img ubuntu-base.qcow
rm tmp.img
rm -r $tmp_mnt
