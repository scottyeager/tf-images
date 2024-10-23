#!/bin/bash

# Makes a qcow2 image from a tar archive
# Also copies kernel and initrd to pwd
# Takes one argument: path to archive

archive=$(realpath $1)

mkdir -p tmp
sudo rm -rf tmp/*
cd tmp
mkdir mnt

dd if=/dev/null of=tmp.img bs=1M seek=2048
mkfs.ext3 tmp.img

sudo mount -t ext3 -o loop tmp.img mnt

sudo tar xf $archive -C mnt
sudo cp mnt/boot/initrd.img ./
sudo cp mnt/boot/vmlinuz ./
sudo chmod +r vmlinuz

sudo umount mnt
qemu-img convert -O qcow2 tmp.img image.qcow

rm tmp.img
rm -rf mnt

qemu-system-x86_64 -m 512 \
                   -kernel vmlinuz \
                   -initrd initrd.img \
                   -drive file=image.qcow,if=virtio \
                   -drive file=../seed.img,if=virtio \
                   -append "root=/dev/vda console=ttyS0 rw" \
                   -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22 \
                   -nographic
