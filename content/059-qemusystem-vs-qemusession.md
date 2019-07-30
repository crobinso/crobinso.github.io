Title: qemu:///system vs qemu:///session
Date: 2016-01-11 08:00
Author: Cole Robinson
Tags: fedora, virt
Slug: qemusystem-vs-qemusession
Status: published

If you've spent time using libvirt apps like virt-manager, you've likely seen references to [libvirt URIs](https://libvirt.org/uri.html). The URI is how users or apps tell libvirt what hypervisor (qemu, xen, lxc, etc) to connect to, what host it's on, what authentication method to use, and a few other bits. 

For QEMU/KVM (and a few other hypervisors), there's a concept of **system** URI vs **session** URI:

-   **`qemu:///system`**: Connects to the **system** libvirtd instance, the one launched by systemd. libvirtd is running as root, so has access to all host resources. qemu VMs are launched as the unprivileged 'qemu' user, though libvirtd can grant the VM selective access to root owned resources. Daemon config is in `/etc/libvirt`, VM logs and other bits are stored in `/var/lib/libvirt`. virt-manager and big management apps like Openstack and oVirt use this by default.
-   **`qemu:///session`**: Connects to a **session** libvirtd instance running as the app user, the daemon is auto-launched if it's not already running. libvirt and all VMs run as the app user. All config and logs and disk images are stored in `$HOME`. This means each user has their own `qemu:///session` VMs, separate from all other users. gnome-boxes and libguestfs use this by default.

That describes the 'what', but the 'why' is a bigger story. The privilege level of libvirtd and VMs have pros and cons depending on your usecase. The easiest way to understand the benefit of one over the other is to list the <u>problems</u> with each setup.


#### qemu:///system

With `qemu:///system`,  libvirtd runs as root, and app access to libvirtd is mediated by polkit. This means if you are connecting to `qemu:///system` as a regular user (like via default virt-manager usage), you need to enter the host root password, which is annoying and not generally desktop usecase friendly. There are [ways to work around it](https://blog.wikichoon.com/2016/01/polkit-password-less-access-for-libvirt.html) but it requires explicit admin configuration.

Desktop use cases also suffer as VMs are run as the `qemu` user, but the app (like virt-manager) is running as your local user. For example, say you download an ISO to `$HOME` and want to attach it to a VM. The VM is running as unprivileged user `qemu` and can't access your `$HOME`, so libvirt has to change the ISO file owner to `qemu:qemu` and virt-manager has to give search access to `$HOME` for user `qemu`. It's a pain for apps to handle, and it's confusing for users, but after dealing with it for a while in virt-manager we've made it generally work. (Though try giving a VM access to a file on a fat32 USB drive that was automounted by your desktop session...)


#### qemu:///session

With `qemu:///session`, libvirtd and VMs run as your unprivileged user. This integrates better with desktop use cases since permissions aren't an issue, no root password is required, and each user has their own separate pool of VMs.

However because nothing in the chain is privileged, any VM setup tasks that need host admin privileges aren't an option. Unfortunately this includes most general purpose networking options.

The default qemu network mode when running unprivleged is [usermode networking (or SLIRP)](https://wiki.qemu.org/Documentation/Networking#User_Networking_.28SLIRP.29). This is an IP stack implemented in userspace. This has many drawbacks: the VM can not easily be accessed by the outside world, the VM can talk to the outside world but only over a limited number of networking protocols, and it's very slow.

There <u>is</u> an option for qemu:///session VMs to use a privileged networking setup, via the setuid [qemu-bridge-helper](https://wiki.qemu.org/Features-Done/HelperNetworking). Basically the host admin sets up a bridge, adds it to a whitelist at `/etc/qemu/bridge.conf`, then it's available for unprivileged qemu instances. By default on Fedora this contains `virbr0` which is the default virtual network bridge provided by the system libvirtd instance, and what `qemu:///system` VMs typically use.

gnome-boxes originally used usermode networking, but switched around Fedora 21 timeframe to use `virbr0` via qemu-bridge-helper. But that's dependent on `virbr0` being set up correctly by the host admin, or via package install (`libvirt-daemon-config-network` package on Fedora).

`qemu:///session` also misses some less common features that require host admin privileges, like host PCI device assignment. Also VM autostart doesn't work as expected because the session daemon itself isn't autostarted.


#### How to decide
App developers have to decide for themselves which libvirtd mode to use, depending on their use case.

`qemu:///system` is completely fine for big apps like oVirt and Openstack that require admin access to the virt hosts anyways.

virt-manager largely defaults to `qemu:///system` because that's what it has always done, and that default long precedes qemu-bridge-helper. We could switch but it would just trade one set of issues for another. virt-manager <u>can</u> be used with `qemu:///session` though (or any URI for that matter).

libguestfs uses `qemu:///session` since it avoids all the permission issues and the VM appliance doesn't really care about networking.

gnome-boxes prioritized desktop integration from day 1, so `qemu:///session` was the natural choice. But they've struggled with the networking issues in various forms.

Other apps are in a pickle: they would like to use qemu:///session to avoid the permission issues, but they also need to tweak the network setup. This is the case [vagrant-libvirt currently finds itself in](https://github.com/pradels/vagrant-libvirt/issues/272).
