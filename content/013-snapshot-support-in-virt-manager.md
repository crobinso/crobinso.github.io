Title: Snapshot support in virt-manager
Date: 2014-03-17 14:05
Author: Cole Robinson
Tags: fedora, virt
Slug: snapshot-support-in-virt-manager
Status: published


The biggest feature we added in [virt-manager 1.0](http://blog.wikichoon.com/2014/02/virt-manager-100-released.html) is VM snapshot support. Users have been asking us to expose this in the UI for quite a long time. In this post I'll walk you through the new UI.

Let's start with some use cases for VM snapshots:

1.  I want to test some changes to my VM, and either throw them away, or use them permanently.
2.  I want to have a single Fedora 20 VM, but multiple snapshots with mutually exclusive OS changes in each. One snapshot might have F20 libvirt installed, but another snapshot will have libvirt.git installed. I want to switch between them for development, bug triage, etc.
3.  I encountered a bug in the VM. I want to save the running state of the VM incase developers want further debugging information, but I also want to restart the VM and continue to use it in the meantime.

The libvirt APIs support two different types of snapshots with qemu/kvm.


#### Internal snapshots


Internal snapshots are the snapshots that QEMU has supported for a long time. Libvirt refers to them as 'internal' because all the data is stored as part of the qcow2 disk image: if you have a VM with a single qcow2 disk image and take 10 snapshots, you still have only one file to manage. This is the default snapshot mode if using the 'virsh snapshot-\*' commands.

These snapshots can be combine disk and VM memory state for 'checkpointing', so you can jump back and forth between a saved running VM state. A snapshot of an offline VM can also be performed, and only the disk contents will be saved.

Cons:

-   Only works with qcow2 disk images. Since virt-manager has historically used raw images, pre-existing VMs may not be able to work with this type.
-   They are non-live, meaning the VM is paused while all the state is saved. For end users this likely isn't a problem, but if you are managing a public server, minimizing downtime is essential.
-   Historically they were quite slow, but this has improved quite a bit with QEMU 1.6+



#### External snapshots


External snapshots are about safely creating [copy-on-write overlay files](http://wiki.qemu.org/Documentation/CreateSnapshot) for a running VM's disk images. QEMU has supported copy-on-write overlay files for a long time, but the ability to create them for a running VM is only a couple years old. They are called 'external' because every snapshot creates a new overlay file.

While the overlay files have to be qcow2, these snapshots will work with any base disk image. They can also be performed with very little VM downtime, at least under a second. The external nature also allows different use cases like live backup: create a snapshot, back up the original backing image, when backup completes, merge the overlay file changes back into the backing image.

However that's mostly where the benefits end. Compared to internal snapshots, which are an end to end solution with all the complexity handled in QEMU, external snapshots are just a building block for handling the use cases I described above... and the many of the pieces haven't been filled in yet. Libvirt still needs [a lot of work](http://wiki.libvirt.org/page/I_created_an_external_snapshot,_but_libvirt_won%27t_let_me_delete_or_revert_to_it) to reach feature parity with what internal snapshots already provide. This is understandable, as the main driver for external snapshot support was for features like live backup that internal snapshots weren't suited for. Once that point was reached, there hasn't been much of a good reason to do the difficult work of filling in the remaining support when internal snapshots already fit the bill.


#### virt-manager support


Understandably we decided to go with internal snapshots in virt-manager's UI. To facilitate this, we've changed the default disk image for new qemu/kvm VMs to **qcow2**.

The snapshot UI is reachable via the VM details toolbar and menu:


[![](http://4.bp.blogspot.com/-NHIb6TbX5MU/UyXr45_n3mI/AAAAAAAAADE/AO3vok9OpTM/s1600/Screenshot+from+2014-03-16+14:21:49.png){width="320" height="158"}](http://4.bp.blogspot.com/-NHIb6TbX5MU/UyXr45_n3mI/AAAAAAAAADE/AO3vok9OpTM/s1600/Screenshot+from+2014-03-16+14:21:49.png)


That button will be disabled with an informative tool tip if snapshots aren't supported, such as if the the disk image isn't qcow2, or using a libvirt driver like xen which doesn't have snapshot support wired up.

Here's what the main screen looks like:


[![](http://2.bp.blogspot.com/-5vmjChe5sHQ/UyXv-N5iDmI/AAAAAAAAADQ/mWa1zIPIFag/s1600/Screenshot+from+2014-03-16+14:39:18.png){width="640" height="627"}](http://2.bp.blogspot.com/-5vmjChe5sHQ/UyXv-N5iDmI/AAAAAAAAADQ/mWa1zIPIFag/s1600/Screenshot+from+2014-03-16+14:39:18.png)


It's pretty straight forward. The column on the left lists all the snapshots. The 'VM State' means *the state the VM was in when the snapshot was taken*. So running/reverting to a 'Running' snapshot means the VM will end up in a running state, a 'Shutoff' snapshot will end up with the VM shutoff, etc.

The check mark indicates the *last applied snapshot*, which could be the most recently created snapshot or the most recently run/reverted snapshot. The VM disk contents are basically 'the snapshot contents' + 'whatever changes I've made since then'. It's just an indicator of where you are.

Internal snapshots are all independent of one another. You can take 5 successive snapshots, delete 2-4, and snapshot 1 and 5 will still be completely independent. Any notion of a snapshot hierarchy is really just metadata, and we decided not to expose it in the UI. That may [change in the future](https://bugzilla.redhat.com/show_bug.cgi?id=1065077).

Run/revert to a snapshot with the play button along the bottom. Create a new snapshot by hitting the + button. The wizard is pretty simple:


[![](http://1.bp.blogspot.com/-h45EjtteJJk/UyXx3OybSrI/AAAAAAAAADc/QNVyzJAADJo/s1600/Screenshot+from+2014-03-16+14:47:26.png){width="359" height="400"}](http://1.bp.blogspot.com/-h45EjtteJJk/UyXx3OybSrI/AAAAAAAAADc/QNVyzJAADJo/s1600/Screenshot+from+2014-03-16+14:47:26.png)


That's about it. Give it a whirl in virt-manager 1.0 and [file a bug](http://virt-manager.org/bugs/) if you hit any issues.
