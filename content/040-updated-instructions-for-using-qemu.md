Title: Updated instructions for using QEMU, UEFI, and Secureboot
Date: 2014-11-23 17:15
Author: Cole Robinson
Tags: fedora, virt
Slug: updated-instructions-for-using-qemu
Status: published

Last year I started a wiki page about testing [Fedora's Secureboot support](http://fedoraproject.org/wiki/Secureboot) with KVM. Just now I've cleaned up the page and modernized it for the current state of virt packages in F21:

<https://fedoraproject.org/wiki/Using_UEFI_with_QEMU>

The Secureboot steps are now at:

<https://fedoraproject.org/wiki/Using_UEFI_with_QEMU#Testing_Secureboot_in_a_VM>

The main change is that nowadays the virt tools know how to create persistent configuration storage for UEFI, so you can setup Secureboot once. Previously you had to do all sorts of crazy things to turn on Secureboot for each restart of the VM.
