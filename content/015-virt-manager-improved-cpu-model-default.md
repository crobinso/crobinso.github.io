Title: virt-manager: Improved CPU model default
Date: 2014-03-25 14:18
Author: Cole Robinson
Tags: fedora, virt
Slug: virt-manager-improved-cpu-model-default
Status: published

In [virt-manager 1.0](https://blog.wikichoon.com/2014/02/virt-manager-100-released.html) we improved many of the defaults we set when creating a new virtual machine. One of the major changes was to how we choose the [CPU model](https://wiki.qemu.org/Features/CPUModels) that's exposed to the VM OS.

CPU model here means something like 'Pentium 3' or 'Opteron 4' and all the CPU flags that go along with that. For KVM, every CPU flag that we expose to the VM has to be something provided by the host CPU, so we can't just unconditionally tell the VM to use the latest and greatest features. The newer the CPU that's exposed to the guest, the more features the guest kernel and userspace can use, which improves performance.

There's a few trade offs however: if [live migrating](https://www.linux-kvm.org/page/Migration) your VM, the destination host CPU needs to be able to represent all the features that have been exposed to the VM. So if your VM is using 'Opteron G5', but your destination host is only an 'Opteron G4', the migration will fail. And changing the VM CPU after OS installation can cause Windows VMs to require reactivation, which can be problematic. So in some instances you are stuck with the CPU model the VM was installed with.

Prior to virt-manager 1.0, new VMs received the hypervisor default CPU model. For qemu/kvm, that's qemu64, a made up CPU with very few feature flags. This leads to less suboptimal guest OS performance but maximum migration compatibility.

But the reality is that cross host migration is not really a major focus of virt-manager. Migration is all about preserving uptime of a server VM, but most virt-manager users are managing VMs for personal use. It's a bigger win to maximize out of the box performance.

For virt-manager 1.0, we wanted new VMs to have an identical copy of the host CPU. There's two ways to do that [via libvirt](https://libvirt.org/formatdomain.html#elementsCPU):

1.  **mode=host-passthrough**: This maps to the 'qemu -cpu host' command line. However, this option is explicit not recommended for libvirt usage. libvirt wants to fully specify a VM's hardware configuration, to insulate the VM from any hardware layout changes when qemu is updated on the host. '-cpu host' defers to qemu's detection logic, which violates that principle.
2.  **mode=host-model**: This is libvirt's attempted reimplementation of '-cpu host', and is the recommended solution in this case. However the current implementation has [quite a few problems](https://bugzilla.redhat.com/show_bug.cgi?id=1055002). The issues won't affect most users, and they are being worked on, but for now host-model isn't safe to use as a general default.

So for virt-manager 1.0, we compromised to using the nearest complete CPU model of the host CPU. This requires a bit of explanation. There are multiple CPUs on the market that are labelled as 'core2duo'. They all share a fundamental core of features that define what 'core2duo' means. But some models also have [additional]{.underline} features. virt-manager 1.0 will ignore those extra bits and just pass 'core2duo' to your VM. This is the best we can do for performance at the moment without hitting the host-model issues mentioned above.

However this default is configurable: if you want to return to the old method that maximizes migration compatibility, or you want to try out host-model, you can change the default for new VMs in Edit-\>Preferences:


![CPU model preferences]({static}/images/015-virt-manager-improved-cpu-model-default-1.png){width="320" height="299"}
