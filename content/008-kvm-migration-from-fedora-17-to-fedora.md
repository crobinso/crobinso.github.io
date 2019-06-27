Title: KVM migration from Fedora 17 to Fedora 21+ is not supported
Date: 2013-12-03 18:50
Author: Cole Robinson
Tags: fedora
Slug: kvm-migration-from-fedora-17-to-fedora
Status: published

With qemu 1.7.0 in rawhide/Fedora 21, we've dropped some non-upstream back compatibility patches that allow migration from Fedora 17 vintage qemu and earlier.

This affects not just live migration (which I doubt anyone cares about in this context), but also any qemu memory snapshots or libvirt 'save' data created on or before Fedora 17. Trying to restore this data on F21 will not work.

In reality I don't expect this to affect anybody really. If you have saved data or snapshots that are important, you can load/restore them on Fedora 20, fully poweroff the VM, virsh edit and change the machine= value to something newer like pc-1.6, start the VM, and recreate the data to the best of your ability. save data/memory snapshots created on F20 will load correctly on F21. I realize this isn't ideal but hopefully no one is affected and it doesn't matter in practice.

Some background: In Fedora 17 and earlier, we shipped a qemu package based on [qemu-kvm.git](https://git.kernel.org/cgit/virt/kvm/qemu-kvm.git), which was a fork of [qemu.git](https://git.qemu.org/qemu.git) containing KVM support and a few other bits. Over time the QEMU and KVM community worked to merge all the forked bits into mainline qemu, which was fully completed with the qemu 1.3 release. Fedora 18 was the first Fedora release to ship this merged codebase

Unfortunately, qemu-kvm.git had accumulated some unintentional incompatibilities with qemu.git: minor internal bits that affected migration but had little other functional impact. The end result was that a qemu-kvm-1.2 guest could not be migrated to the new merged qemu-1.3.

This sucked for Fedora where we had always shipped qemu-kvm.git: migration/saves/snapshots made on Fedora 17 would not work on Fedora 18, and there would be no easy upgrade path. So we decided to maintain this migration back compatibility with qemu-kvm.git. However this required non-upstream patches, which we obviously do not want to carry forever.

I think after 3 stable releases (F20 is out soon enough) this shouldn't have much practical impact, so bye bye non-upstream patches :)
