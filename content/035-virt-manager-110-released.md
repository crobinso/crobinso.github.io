Title: virt-manager 1.1.0 released!
Date: 2014-09-07 17:25
Author: Cole Robinson
Tags: fedora, virt
Slug: virt-manager-110-released
Status: published

virt-manager 1.1.0 is released! ... and should show up in F21 and rawhide shortly.

This release includes:

-   Switch to libosinfo as OS metadata database (Giuseppe Scrivano)
-   Use libosinfo for OS detection from CDROM media labels (Giuseppe Scrivano)
-   Use libosinfo for improved OS defaults, like recommended disk size (Giuseppe Scrivano)
-   virt-image tool has been removed, as [previously announced](https://blog.wikichoon.com/2014/04/deprecating-little-used-tool-virt-image1.html)
-   [Enable Hyper-V enlightenments for Windows VMs](https://blog.wikichoon.com/2014/07/enabling-hyper-v-enlightenments-with-kvm.html)
-   Revert virtio-console default, back to plain serial console
-   Experimental q35 option in new VM 'customize' dialog
-   UI for virtual network QoS settings (Giuseppe Scrivano)
-   virt-install: --disk discard= support (Jim Minter)
-   addhardware: Add spiceport UI (Marc-André Lureau)
-   virt-install: --events on\_poweroff etc. support (Chen Hanxiao)
-   cli --network portgroup= support and UI support
-   cli --boot initargs= and UI support
-   addhardware: allow setting controller model (Chen Hanxiao)
-   virt-install: support setting hugepage options (Chen Hanxiao)
