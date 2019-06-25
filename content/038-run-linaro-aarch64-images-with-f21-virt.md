Title: Run linaro aarch64 images with f21 virt-install + libvirt
Date: 2014-11-19 12:25
Author: Cole Robinson
Tags: fedora, virt
Slug: run-linaro-aarch64-images-with-f21-virt
Status: published

Linaro generates some minimal openembedded based aarch64 disk images, which are useful for virt testing. There's simple instructions [over here](http://suihkulokki.blogspot.com/2014/08/booting-linaro-armv8-oe-images-with-qemu.html) for running them with qemu on an x86 host. But with Fedora 21 packages, you can also these images with virt-install + libvirt + qemu.

-   Grab the disk image, I used this one: <http://releases.linaro.org/14.10/openembedded/aarch64/vexpress64-openembedded_minimal-armv8-gcc-4.9_20141023-693.img.gz>
-   Grab the associated boot bits: <http://releases.linaro.org/14.10/openembedded/aarch64/Image>
-   Extract the disk image: `unar vexpress64-openembedded_minimal-armv8-gcc-4.9_20141023-693.img.gz`


Finally, import it with virt-install. The command and output are:

```
$ sudo virt-install
     --name linaro-aarch64 --ram 1024
     --arch aarch64 --cpu cortex-a57
     --disk vexpress64-openembedded_minimal-armv8-gcc-4.9_20141023-693.img
     --boot machine=virt,kernel=Image,kernel_args="root=/dev/vda2 rw rootwait mem=1024M console=ttyAMA0,38400n8"

Starting install...
Creating domain...                                     |    0 B  00:00   
Connected to domain linaro-aarch64
Escape character is ^]
[    0.000000] Linux version 3.17.0-1-linaro-vexpress64 (buildslave@x86-64-07) (gcc version 4.8.3 20140401 (prerelease) (crosstool-NG linaro-1.13.1-4.8-2014.04 - Linaro GCC 4.8-2014.04) ) #1ubuntu1~ci+141022120835 SMP PREEMPT Wed Oct 22 12:09:19 UTC 20
[    0.000000] CPU: AArch64 Processor [411fd070] revision 0
[    0.000000] Detected PIPT I-cache on CPU0
[    0.000000] Memory limited to 1024MB
...
Last login: Wed Nov 19 17:16:22 UTC 2014 on tty1
root@genericarmv8:~#
```

(Maybe you're wondering, what about fedora images? They are a bit different, since they expect to run with UEFI. I'll blog about that soon once I finish some testing)
