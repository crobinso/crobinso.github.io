Title: Running KVM arm 32 on AArch64
Date: 2016-01-08 09:00
Author: Cole Robinson
Tags: fedora, virt
Slug: running-kvm-arm-32-on-aarch64
Status: published

Just a little tip: [libvirt 1.2.17](https://www.redhat.com/archives/libvirt-announce/2015-July/msg00002.html) fixed the last bits necessary to run 32bit arm VMs on AArch64 hosts with KVM acceleration. We just needed to [make sure](https://github.com/libvirt/libvirt/commit/daf2f514456c03ce99075b359b14e5108dd2da56) that libvirt advertised the capability, all the lower level qemu and kernel bits were already in place.

Just select **armv7l** in virt-manager's UI when creating a new VM, or pass **--arch armv7l** to virt-install, if on an aarch64 host, and KVM will be used if it's available.

In my (very brief) testing the VM seems to be much faster than 32-on-32 KVM, but I don't think that's a surprise given the speed difference between the host machines.

Update: Marcin [posted](https://marcin.juszkiewicz.com.pl/2016/01/17/running-32-bit-arm-virtual-machine-on-aarch64-hardware/) some virt-manager screenshots and performance info.
