#!/bin/bash

qemu-img create -f qcow2 -F qcow2 -b ubuntu-base.qcow ubuntu-run.qcow
qemu-system-x86_64 -m 512 \
                   -kernel vmlinuz \
                   -initrd initrd.img \
                   -hda ubuntu-run.qcow \
                   -hdb seed.img \
                   -append "root=/dev/sda console=ttyS0 rw" \
                   -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22 \
                   -nographic
