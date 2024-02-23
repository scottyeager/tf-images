#!/bin/bash

# Makes a qcow2 image from a tar archive
# Also copies kernel and initrd to pwd
# Takes one argument: path to archive

archive=$1
name=$(basename -s .tar.gz $1)

dd if=/dev/null of=tmp.img bs=1M seek=512
mkfs.ext3 tmp.img

tmp_mnt=$(mktemp -d)
sudo mount -t ext3 -o loop tmp.img $tmp_mnt

sudo tar xf $archive -C $tmp_mnt 
cp $tmp_mnt/boot/initrd.img ./
cp $tmp_mnt/boot/vmlinuz ./

sudo umount $tmp_mnt
qemu-img convert -O qcow2 tmp.img ${name}-base.qcow
rm tmp.img
rm -r $tmp_mnt
