Title: virt-install: create disk image without an explicit path
Date: 2014-07-27 16:19
Author: Cole Robinson
Tags: fedora, virt
Slug: virt-install-create-disk-image-without
Status: published

For most of its life, virt-install has required specifying an explicit disk path when creating storage, like:


`virt-install --disk /path/to/my/new/disk.img,size=10 ...`


However there's a shortcut since version 1.0.0, just specify the size:

`virt-install --disk size=10 ...`

virt-install will create a disk image in the [default pool](https://blog.wikichoon.com/2014/07/virt-manager-changing-default-storage.html), and name it based on the VM name and disk image format, typically `$vmname.qcow2`.
