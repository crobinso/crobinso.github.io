Title: virt-manager: changing the default storage path and default virtual network
Date: 2014-07-15 15:45
Author: Cole Robinson
Tags: fedora, virt
Slug: virt-manager-changing-default-storage
Status: published

When creating a new virtual machine via virt-manager or virt-install, the tools make some assumptions about the default location for disk images, and the default network source.

For example, in the **New VM** wizard, the storage page will offer to create a disk image in the default location:


![virt-manager default storage UI]({static}/images/029-virt-manager-changing-default-storage-1.png){width="367" height="400"}


The default location for most uses of virt-manager is `/var/lib/libvirt/images`, which is created by libvirt and has the expected selinux labelling and permission to run QEMU/KVM VMs.

Behind the scenes, virt-manager is using a libvirt storage pool for creating disk images. When the **New VM** wizard is first run, virt-manager looks for a storage pool named **default**; if it doesn't find that it will create a storage pool named **default** pointing to `/var/lib/libvirt/images`. It then uses that **default** pool for the disk provisioning page.

The default virtual network works similarly. The libvirt-daemon-config-network package will dynamically create a libvirt virtual network named **default**. You can see the XML definition [over here](https://libvirt.org/git/?p=libvirt.git;a=blob;f=src/network/default.xml;h=d7241d0c16271bb7598b5bc1bb90d8145183de50;hb=HEAD) in libvirt.git.

When virt-manager reaches the last page of the **New VM** wizard, if there's a virtual network named **default**, we automatically select it as the network source:


![virt-manager default network UI]({static}/images/029-virt-manager-changing-default-storage-2.png){width="285" height="400"}


It's also the network source used when no explicit network configuration is passed to `virt-install`.

Every now and then someone asks how to make virt-manager/virt-install use a different storage pool or network as the default. As the above logic describes, just name the desired virtual network or storage pool **default**, and the tools will do the right thing.

You can rename storage pools and virtual networks using virt-manager's UI from **Edit-\>Connection Details**. It only works on a stopped object though. Here's an example renaming a virtual network **default** to **new-name**:


![virt-manager rename virtual network UI]({static}/images/029-virt-manager-changing-default-storage-3.png){width="640" height="481"}
