Title: Spice USB redirection in virt-manager
Date: 2014-04-01 10:00
Author: Cole Robinson
Tags: fedora, virt
Slug: spice-usb-redirection-in-virt-manager
Status: published

A new feature we added in [virt-manager 1.0](https://blog.wikichoon.com/2014/02/virt-manager-100-released.html) is out of the box support for **Spice USB redirection**.

When connected to a VM's graphical display, any USB device plugged in to your physical host will be automatically redirected to the VM. This is great for easily sharing a usb drive with your VM. Existing devices can also be manually attached via the VM window menu option **Virtual Machine-\>Redirect USB Device**

The great thing about Spice USB redirection is that it doesn't require configuring the spice agent or any special drivers inside the VM, so for example it will 'just work' for your existing windows VMs. And since the streaming is done via the spice display widget, you can easily share a local USB device with a VM on a remote host.

This feature is only properly enabled for KVM VMs that are created with virt-manager 1.0 or later. Configuring an existing VM requires 3 changes:

1.  Set the graphics type to **Spice**
2.  Set the USB controller model to **USB2**
3.  Add a **Redirection USB** device to the VM. Add multiple redirection devices to allow redirecting multiple host USB devices simultaneously.

All those bits should be fairly straight forward to do with the UI in virt-manager 1.0.

For more details, like how to do this using libvirt XML or the qemu command line, check the documentation over here:

<https://people.freedesktop.org/~teuf/spice-doc/html/>
