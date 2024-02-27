# Encrypted VM image

This image uses `overlayroot` to make the original root filesystem read only and direct all writes to an encrypted block device.

As configured, the encryption keys are ephemeral and generated at boot. This effectively means that any data the VM writes to disk can be read by no one, even the owner of the VM, if it is ever rebooted. The corollary fact is that a VM deployed from this image appears fresh on each boot.

The default behavior is to store the encrypted overlay data on `/dev/vda`, which on the TF Grid will be the first attached disk.

Kernel version `5.19-generic` is chosen for two reasons. First, it has the necessary `dm-crypt` module that's missing in `-kvm` kernels. Second, the 5.15 kernels don't play well with the virtio filesystem, that Zos provides for root, as the underlay in this scheme.
