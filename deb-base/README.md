# Debian and Ubuntu Base

The Dockerfile contained here generates Docker images with `sshd` and `zinit`, for use as micro VM images on the ThreeFold Grid. It accepts a parent image name and tag as build arguments, and should generally work with any `apt` based distro.

Here is a brief description of the steps and components included:

1. Install `openssh-server` and `busybox` packages. Skip recommended packages, which for `openssh-server` includes almost 100mb of packages, some of which are desktop specific
2. Remove the auto generated SSH host keys, and create the privilege separation folder, `/var/run/sshd`
3. Use `busybox --install` to create symlinks for all busybox commands that don't exist yet in `/usr/bin`. This has the side effect that any packages installed later which provide these tools will overwrite the busybox version. This provides us some basic utilities like `ip` and `ping` that are otherwise missing in Ubuntu/Debian container images
4. Download `zinit`, make it executable, and copy in the unit files and SSH init script
5. `ssh-init.sh` will generate fresh host keys at first start of the image, and also set up `authorized_keys` if needed (this is done automatically by Zos when the image is started as a micro VM, but is helpful for testing that `sshd` is working properly when running images locally with Docker)
