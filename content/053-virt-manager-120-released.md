Title: virt-manager 1.2.0 released!
Date: 2015-05-04 21:55
Author: Cole Robinson
Tags: fedora, virt
Slug: virt-manager-120-released
Status: published

Today I released virt-manager-1.2.0. You can read the release announcement [here](https://www.redhat.com/archives/virt-tools-list/2015-May/msg00010.html)

This release includes:

-   OVMF/AAVMF Support (Laszlo Ersek, Giuseppe Scrivano, Cole Robinson)
-   Improved support for AArch64 qemu/kvm
-   virt-install: Support --disk type=network parameters
-   virt-install: Make --disk $URL just work
-   virt-install: Add --disk sgio= option (Giuseppe Scrivano)
-   addhardware: default to an existing bus when adding a new disk (Giuseppe Scrivano)
-   virt-install: Add --input device option
-   virt-manager: Unify storagebrowser and storage details functionality
-   virt-manager: allow setting a custom connection row name
-   virt-install: Support --hostdev scsi passthrough
-   virt-install: Fill in a bunch of --graphics spice options
-   Disable spice image compression for new local VMs
-   virt-manager: big reworking of the migration dialog
