# Full VM in Docker

Use this to generate an Ubuntu full VM image for direct kernel booting. It's an alternative to the process shown [here](https://github.com/threefoldtech/zos/blob/main/docs/manual/zmachine/zmachine.md#vm), done almost fully in Docker.

To build the default image, just:

```
./build.sh
```

The output is a compressed tar archive `ubuntu-fullvm.tar.gz`, which is ready for upload to [the Hub](https://hub.grid.tf/upload).

Some parts of this script use `sudo` in order to maintain the root user as owner of files. Maybe we could also do these steps inside a container.

## Hacking

Any customizations should be done during the second phase, `FROM scratch`. Just place any `apt` commands before the final cleanup steps to make sure the package lists are there.

The script will leave an image `ubuntu:gridfullvm` on your system. You can do a `docker run -it ubuntu:gridfullvm bash` to check this out and play around, but since it's not actually started with `systemd` you won't get the full experience.

To test an image without actually running it on the Grid, qemu works fine. Here's an example of making a raw image with ext3 filesystem holding the image contents:

```
#!/bin/bash

dd if=/dev/null of=ubuntu.img bs=1M seek=1024
mkfs.ext3 ubuntu.img
sudo mkdir -p /mnt/raw
sudo mount -t ext3 -o loop ubuntu.img /mnt/raw/
sudo tar xf $1 -C /mnt/raw
sudo rm /mnt/raw/.dockerenv
cp /mnt/raw/boot/initrd.img-5.15.0-1004-kvm ./
cp /mnt/raw/boot/mlinuz-5.15.0-1004-kvm ./
sudo umount /mnt/raw
```

Now the kernel and initrd will also be copied into the current folder. Boot up the image like this (you'll [need](https://cloudinit.readthedocs.io/en/21.4/topics/faq.html#cloud-localds) a `seed.img` for `cloud-init` to work):
```
qemu-img convert -O qcow2 ubuntu.img ubuntu.qcow #Make a fresh copy so any changes can be discarded
qemu-system-x86_64 -m 512 -kernel vmlinuz-5.15.0-1004-kvm \
                          -initrd initrd.img-5.15.0-1004-kvm \
                          -hda ubuntu.qcow \
                          -hdb seed.img \
                          -append "root=/dev/sda console=ttyS0 rw" \
                          -nic user,model=virtio-net-pci,hostfwd=tcp::2222-:22 \
                          -nographic
```

Now the VM should be accessible by SSH at localhost port 2222:

```
ssh -p 2222 root@localhost
```

## Notes

* Using `debootstrap` inside a container is somewhat precarious. I found `minbase` to work more reliably than the default manifest
* `kvm` kernel is much leaner because drivers for physical hardware aren't needed in VM
* For some of the packages installed in the final image it's not obvious why they're needed
  * `binutils` provides `readelf`, which is required by `extract-vmlinux`
  * `lsb-release` is used by `cloud-init`
  * Without `libpam-systemd`, systemctl doesn't work properly
* Probably there are some things missing that users would expect to find (it's a rather minimal system)
