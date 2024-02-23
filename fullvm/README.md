# Full VM in Docker

Use this to generate an Ubuntu full VM image for direct kernel booting. It's an alternative to the process shown [here](https://github.com/threefoldtech/zos/blob/main/docs/manual/zmachine/zmachine.md#vm), but done entirely in Docker containers.

To build an image, run the build script and pass the name of the folder. For example, to build the minimal image, do:

```
./build.sh ubuntu-minimal
```

The output is a compressed tar archive inside the given folder, which is ready for upload to [the Hub](https://hub.grid.tf/upload).

The build script will also leave a Docker image on your system with the same name. This image can be run in Docker for limited testing and debug, but since it's not actually started with `systemd` you won't get the full experience.

## Hacking

To make a new image, just copy one folder and make your customizations in the Dockerfile. Most changes should go in the heredoc'd script section (`RUN <<EOF`). 

Once you build the image, it's possible to use `docker run -it <image name> bash` to have a look around. There's also a script `freeze.sh` that can save any changes from a live container into an image for quick testing without updating the Dockerfile and rebuilding. Just pass it the container hash or name, for example:

```
docker run -it ubuntu-minimal bash
# root@06179ea45549:/# apt install vim
./freeze.sh 06179ea45549
```

This places a tar archive of your frozen container in the current directory, which is ready to be tested by running it as a VM.
 
## Testing in QEMU

There's also a script that takes an image archive and runs it in QEMU as a VM. You'll need `qemu-system` and `qemu-img` installed for this part.

To get started, generate yourself a seed image, to pass your SSH key to the VM via `cloud-init`:

```
./seed.sh
```

Now you can test any image by passing it to the `test.sh` script:

```
./test.sh ubuntu-minimal/ubuntu-minimal.tar.gz
```

Wait for the VM to boot up and `cloud-init` to complete. After it states that the authorized keys are written, the VM should be accessible by SSH at localhost port 2222:

```
ssh -p 2222 root@localhost
```

Each run of the test script will generate a fresh image. The artifacts of the test runs are written into `tmp/`. These will be removed before each run, so don't put your own data there.

## Notes

* Using `debootstrap` inside a container is somewhat precarious. I found `minbase` to work more reliably than the default manifest
* `kvm` kernel is much leaner because drivers for physical hardware aren't needed in VM
* For some of the packages installed in the final image it's not obvious why they're needed
  * `binutils` provides `readelf`, which is required by `extract-vmlinux`
  * `lsb-release` is used by `cloud-init`
  * Without `libpam-systemd`, systemctl doesn't work properly
* Probably there are some things missing that users would expect to find (it's a rather minimal system)
