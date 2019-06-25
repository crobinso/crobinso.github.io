Title: Booting Fedora 21 ARM with QEMU and U-Boot
Date: 2014-11-18 15:32
Author: Cole Robinson
Tags: fedora, virt
Slug: booting-fedora-21-arm-with-qemu-and-u
Status: published

Running [Fedora ARM with qemu](https://fedoraproject.org/wiki/Architectures/ARM/F21/Installation#For_Versatile_Express_Emulation_with_QEMU) is a bit of a pain because you need to pull the kernel and initrd out of the disk image and manually pass them to qemu; you can't just point qemu at the disk image and expect it to boot. The latter is how x86 qemu handles it (via a bundles seabios build).

On physical arm hardware, the bit that typically handles fetching the kernel/initrd from disk is U-Boot. However there are no U-Boot builds shipped with qemu for us to take advantage of.

Well that's changed a bit now. I was talking to [Gerd](https://www.kraxel.org/) about this at KVM Forum last month, and after some tinkering he got a working U-Boot build for the Versatile Express board that qemu emulates.

Steps to use it:

-   Grab a Fedora 21 ARM image (I used the F21 beta 'Minimal' image from [here](https://dl.fedoraproject.org/pub/fedora/linux/releases/test/21-Beta/Images/armhfp/))
-   Enable Gerd's upstream [firmware repo](https://www.kraxel.org/repos/)
-   Install `u-boot.git-arm` (this just installs some binaries in /usr/share, doesn't mess with any host boot config)

To use it with libvirt, you can do:

```shell
sudo virt-install --name f21-arm-a9-uboot
 --ram 512
 --arch armv7l --machine vexpress-a9
 --os-variant fedora21
 --boot kernel=/usr/share/u-boot.git/arm/vexpress-a9/u-boot
 --disk Fedora-Minimal-armhfp-21_Beta-1-sda.raw
```


For straight QEMU, you can do:

```
qemu-system-arm -machine vexpress-a9
  -m 512
 -nographic
 -kernel /usr/share/u-boot.git/arm/vexpress-a9/u-boot
 -sd Fedora-Minimal-armhfp-21_Beta-1-sda.raw
```
