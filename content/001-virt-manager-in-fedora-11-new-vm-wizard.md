Title: virt-manager in Fedora 11: 'New VM' wizard redesign
Date: 2009-02-27 14:34
Author: Cole Robinson
Tags: fedora
Slug: virt-manager-in-fedora-11-new-vm-wizard
Status: published

There are some pretty big changes queued up for virt-manager in Fedora 11: foremost among them is a completely redesigned 'New Virtual Machine' wizard.

The current wizard has clearly started to show its age. The original design was largely based on xen specific assumptions and the state of libvirt/virtinst at the time: many of those assumptions don't apply today, or require a bit more thought since we now support both xen and qemu based VMs.

So, some screenshots!

Page 1: VM Name and Install method


[![](http://fedorapeople.org/%7Ecrobinso/virt-manager/newvm2/newvm-pg1-1.png)](http://fedorapeople.org/%7Ecrobinso/virt-manager/newvm2/newvm-pg1-1.png)

We scrapped the 'intro' page: I don't think anyone will miss it. Having the 'name' box occupy an entire page by itself was also a bit overkill, so we did away with that as well.

One of the biggest changes we've made from the old design is that we no longer ask upfront about paravirt vs. fullvirt, VM architecture, or qemu vs. kvm vs. xenner. For new users, this has been an endless pain point ("Why can't I install a PV kvm guest?" among others) and is really a distinction we don't need to force on people: we are certainly in a position to choose sensible defaults (and for kvm, paravirt/virtio has always been setup in the background depending on what OS version is being installed). The logic for the defaults are now as follows:

-   For the qemu libvirt driver, use the first available of the following: kvm, plain qemu, xenner.
-   For the xen libvirt driver, use paravirt if the user selects a URL install and the tree supports it, otherwise use fullvirt.
-   Always default to the host architecture for new VMs.

We allow the user to deviate from these defaults in the final screen under the 'Advanced Options' section.

Also, you'll notice there is a generic 'Computer' icon in the wizard header: this will soon be replaced by a custom icon.

The one new piece here is the option to choose the libvirt connection to install on. Rather than have the 'New' button on the main manager window be conditionally sensitive, the user can now always launch the wizard, choosing the connection from there.


Page 2: Install media info


[![](http://fedorapeople.org/%7Ecrobinso/virt-manager/newvm2/newvm-pg2-local.png)](http://fedorapeople.org/%7Ecrobinso/virt-manager/newvm2/newvm-pg2-local.png)


[![](http://fedorapeople.org/%7Ecrobinso/virt-manager/newvm2/newvm-pg2-url.png)](http://fedorapeople.org/%7Ecrobinso/virt-manager/newvm2/newvm-pg2-url.png)

This hasn't deviated much from the current options: the one difference is that the OS Type/Variant choice has been moved to these screens. This will allow us in the future to offer automatic distro detection based on the selected install media (we may have this for URL installs by the time the release goes out).

Since PXE installs require no extra input, the screen will only have the OS Type/Variant option listed.


Page 3: CPU + Mem details


[![](http://fedorapeople.org/%7Ecrobinso/virt-manager/newvm2/newvm-pg3-1.png)](http://fedorapeople.org/%7Ecrobinso/virt-manager/newvm2/newvm-pg3-1.png)

We dropped the max memory vs. default memory split that is in the existing wizard: it doesn't have much meaning the qemu/kvm world, and even for xen it isn't something that needs to be asked up front. The user can always change it later.

Also, rather than list tons of warning information about overcommitting vcpus, we simply cap the amount at the number available on the host. If for some reason a user wants to allocate more than the host amount of virtual cpus to a VM (say for development purposes) it can easily be done post-install.


Page 4: Storage


[![](http://fedorapeople.org/%7Ecrobinso/virt-manager/newvm2/newvm-pg4-1.png)](http://fedorapeople.org/%7Ecrobinso/virt-manager/newvm2/newvm-pg4-1.png)

The main change here is that we removed the block device vs. file device dichotomy: we are pretty capable of making this distinction behind the scenes.

The option is also now available to skip adding storage altogether: this is useful in the case of Live CDs or diskless PXE booting.

When adding storage, the two options are now:

1 - "Create a disk image on the computer's hard drive": We set up a libvirt storage pool behind the scenes to point to the default location (if using PolicyKit or running as root, this is /var/lib/libvirt/images) and allocate a disk image based on the requested size.

In the future, the default location will be configurable with a global preference.

2 - "Use managed or other existing storage" : This allows pointing to an existing path, or provisioning more complex storage on demand (this is dependent on a libvirt storage API aware browser dialog, which is ongoing work. For the time being, this just launches a local GTK file browser).

The one piece not shown here is the option to choose sparse Vs. non-sparse. We will be putting this back in before the final version is done.


Page 5: Summary and Advanced Options


[![](http://fedorapeople.org/%7Ecrobinso/virt-manager/newvm2/newvm-pg5-1.png)](http://fedorapeople.org/%7Ecrobinso/virt-manager/newvm2/newvm-pg5-1.png)

[![](http://fedorapeople.org/%7Ecrobinso/virt-manager/newvm2/newvm-pg5-2.png)](http://fedorapeople.org/%7Ecrobinso/virt-manager/newvm2/newvm-pg5-2.png)

The summary section is pretty straight forward, no surprises here. The 'Advanced Options' section encompasses networking, hypervisor, and architecture options. The hypervisor and arch defaults were explained above.

For networking, the default is:

-   A bridge device if any exist, else
-   Virtual Network 'default' (comes with libvirt), else
-   First available virtual network, else
-   No networking!

This logic will be globally configurable at some point, e.g. if you wanted to use a specific bridge device or virtual network for all new VMs. We also decided to put all the available networking options into 1 drop down, rather than have 2 separate sections for bridges vs. virtual networking.


I think that covers all the significant bits, hopefully other than that the screenshots speak for themselves. I hope you'll agree it's a much simpler and usable layout. This design was largely done by Tim Allen (former Red Hatter) and Jeremy Perry (current Red Hatter), so a big thank you to them.

Any feedback is appreciated: none of this set in stone.

Thanks,
Cole
