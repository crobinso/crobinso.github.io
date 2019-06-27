Title: virt-manager 1.0 creates qcow2 images that don't work on RHEL6
Date: 2014-12-05 09:09
Author: Cole Robinson
Tags: fedora, virt
Slug: virt-manager-10-creates-qcow2-images
Status: published

One of the big features we added in virt-manager 1.0 was [snapshot support](https://blog.wikichoon.com/2014/03/snapshot-support-in-virt-manager.html). As part of this change, we switched to using the QCOW2 disk image format for new VMs. We also enable the [QCOW2 lazy\_refcounts](https://lists.gnu.org/archive/html/qemu-devel/2012-06/msg03827.html) feature that improves performance of some snapshot operations.

However, not all versions of QEMU in the wild can handle lazy\_refcounts, and will refuse to use the disk image, particularly RHEL6 QEMU. So by default, a disk image from a VM created with Fedora 20 virt-manager will not run on RHEL6 QEMU, throwing an error like:

> ... uses a qcow2 feature which is not supported by this qemu version: QCOW version 3

This has generated some [user](https://bugzilla.redhat.com/show_bug.cgi?id=1119929) [confusion](https://lists.fedoraproject.org/pipermail/virt/2014-April/004040.html).

The 'QCOW version 3' is a bit misleading here: while indeed using lazy\_refcounts sets a bit in the QCOW2 file header calling it QCOW3, qemu-img and libvirt still call it QCOW2, but with a different 'compat' setting.

Kevin Wolf, one of the QEMU block maintainers, explains it in [this mail](https://lists.fedoraproject.org/pipermail/virt/2014-April/004041.html):

> qemu versions starting with 1.1 can use lazy\_refcounts which require an incompatible on-disk format. Between version 1.1 and 1.6, they needed to be specified explicitly during image creation, like this:
>
> qemu-img create -f qcow2 -o compat=1.1 test.qcow2 8G
>
> Starting with qemu 1.7, compat=1.1 became the default, so that newly created images can't be read by older qemu versions by default. If you need to read them in older version, you now need to be explicit about using the old format:
>
> qemu-img create -f qcow2 -o compat=0.10 test.qcow2 8G
>
> With the same release, qemu 1.7, a new qemu-img subcommand was introduced that allows converting between both versions, so you can downgrade your existing v3 image to the format known by RHEL 6 like this
>
> qemu-img amend -f qcow2 -o compat=0.10 test.qcow2

As explained, qemu-img with QEMU 1.7+ also defaults to lazy\_refcounts/compat=1.1, but also provides a 'qemu-img amend' tool to easily convert between the two formats.

Unfortunately that command is not available on Fedora 20 and older, however you can use the pre-existing 'qemu-img convert' command:

`qemu-img convert -f qcow2 -O qcow2 -o compat=0.10 $ORIGPATH $NEWPATH`


Beware though, converting between two qcow2 images will drop all internal snapshots in the new image, so only use that option if you don't need to preserve any snapshot data. 'qemu-img amend' [will]{.underline} preserve snapshot data.

(Unfortunately at this time virt-manager doesn't provide any way in the UI to \_not\_ use lazy\_refcounts, but you could always use qemu-img/virsh to create a disk image outside of virt-manager, and select it when creating a new VM.)
