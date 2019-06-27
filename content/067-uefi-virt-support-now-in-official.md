Title: UEFI virt roms now in official Fedora repos
Date: 2016-06-29 13:27
Author: Cole Robinson
Tags: fedora, virt
Slug: uefi-virt-support-now-in-official
Status: published

[Kamil](https://kparal.wordpress.com/2016/06/27/uefi-for-qemu-now-in-fedora-repositories/) got to it first, but just a note that UEFI roms for x86 and aarch64 virt are now shipped in the standard Fedora repos, where previously the recommended place to grab them was an external nightly repo. Kamil has updated the [UEFI+QEMU wiki page](https://fedoraproject.org/w/index.php?title=Using_UEFI_with_QEMU) to reflect this change.

On up to date Fedora 23+ these roms will be installed automatically with the relevant qemu packages, and libvirt is properly configured to advertise the rom files to applications, so [enabling this with tools like virt-manager](https://blog.wikichoon.com/2016/01/uefi-support-in-virt-install-and-virt.html) is available out of the box.

For the curious, the reason we can now ship these binaries in Fedora is because the problematic EDK2 'FatPkg' code, which had a [Fedora incompatible license](https://fedoraproject.org/w/index.php?title=Using_UEFI_with_QEMU&diff=431056&oldid=423634#EDK2_Licensing_Issues), was replaced with an implementation with a less restrictive (and more Fedora friendly) license.
