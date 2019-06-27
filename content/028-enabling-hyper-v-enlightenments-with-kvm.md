Title: Enabling Hyper-V enlightenments with KVM
Date: 2014-07-07 18:26
Author: Cole Robinson
Tags: fedora, virt
Slug: enabling-hyper-v-enlightenments-with-kvm
Status: published

Windows has support for several paravirt features that it will use when running on Hyper-V, Microsoft's hypervisor. These features are called enlightenments. Many of the features are similar to paravirt functionality that exists with Linux on KVM (virtio, kvmclock, PV EOI, etc.)

Nowadays QEMU/KVM can also enable support for several Hyper-V enlightenments. When enabled, Windows VMs running on KVM will use many of the same paravirt optimizations they would use when running on Hyper-V. For detailed info, see [Vadim's presentation](https://www.linux-kvm.org/wiki/images/0/0a/2012-forum-kvm_hyperv.pdf) from KVM Forum 2012.

From the QEMU/KVM developers, the recommended configuration is:

`-cpu ...,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time`


Which maps to the libvirt XML:


```XML
 <features>
  <hyperv>
   <relaxed state='on'/>
   <vapic state='on'/>
   <spinlocks state='on' retries='8191'/>
  </hyperv>
 <features/>

 <clock ...>
  <timer name='hypervclock' present='yes'/>
 </clock>
```


Some details about the individual features:

-   relaxed/hv\_relaxed. Available in libvirt 1.0.0+ ([commit](https://libvirt.org/git/?p=libvirt.git;a=commit;h=cc922fddc3fcbbcecce7e438a51045c2feacf767)) and qemu 1.1+ ([commit](https://git.qemu.org/?p=qemu.git;a=commit;h=28f52cc04d341045e810bd487a478fa9ec5f40be)). This bit disables a Windows sanity check that commonly results in a BSOD when the VM is running on a heavily loaded host (example bugs [here](https://bugzilla.redhat.com/show_bug.cgi?id=1110305), [here](https://bugzilla.redhat.com/show_bug.cgi?id=990824), and [here](https://bugs.launchpad.net/ubuntu/+source/qemu/+bug/1308341)). Sounds similar to the Linux kernel option no\_timer\_check, which is automatically enabled when Linux is running on KVM.
-   vapic/hv\_vapic. Available in libvirt 1.1.0+ ([commit](https://libvirt.org/git/?p=libvirt.git;a=commit;h=19f75d5eeb6bedd49597034832284146c7591a00)) and qemu 1.1+ ([commit](https://git.qemu.org/?p=qemu.git;a=commit;h=28f52cc04d341045e810bd487a478fa9ec5f40be)).
-   spinlocks/hv\_spinlocks. Available in libvirt 1.1.0+ ([commit](https://libvirt.org/git/?p=libvirt.git;a=commit;h=19f75d5eeb6bedd49597034832284146c7591a00)) and qemu 1.1+ ([commit](https://git.qemu.org/?p=qemu.git;a=commit;h=28f52cc04d341045e810bd487a478fa9ec5f40be))
-   hypervclock/hv\_time. Available in libvirt 1.2.2+ ([commit](https://libvirt.org/git/?p=libvirt.git;a=commit;h=600bca592b2352b683856f4b7f2694f366feac36)) and qemu 2.0+ ([commit](https://git.qemu.org/?p=qemu.git;a=commit;h=48a5f3bcbbbe59a3120a39106bfda59fd1933fbc)). Sounds similar to [kvmclock](https://www.linux-kvm.org/page/KVMClock), a paravirt time source which is used when Linux is running on KVM.


It should be safe to enable these bits for all Windows VM, though only Vista/Server 2008 and later will actually make use of the features.

(In fact, Linux also has support for using these Hyper-V features, like the [paravirt device drivers](https://lwn.net/Articles/342305/) and hyperv\_clocksource. Though these are really only for running Linux on top of Hyper-V. With Linux on KVM, the natively developed paravirt extensions are understandably preferred).

The next version of virt-manager will enable Hyper-V enlightenments when creating a Windows VM ([git commit](https://git.fedorahosted.org/cgit/virt-manager.git/commit/?id=8ea634f9e437153a30f06b7267db2bd685af0561)). virt-xml can also be used to enable these bits easily from the command line for an existing VM:


```shell
$ sudo virt-xml $VMNAME --edit --features hyperv_relaxed=on,hyperv_vapic=on,hyperv_spinlocks=on,hyperv_spinlocks_retries=8191
$ sudo virt-xml $VMNAME --edit --clock hypervclock_present=yes
```


The first invocation will work with virt-manager 1.0.1, the second invocation requires virt-manager.git. In my testing this didn't upset my existing Windows VMs and they worked fine after a reboot.

Other tools aren't enabling these features yet, though there are bugs tracking this for the big ones:

-   ovirt/vdsm: <https://bugzilla.redhat.com/show_bug.cgi?id=1083529>
-   openstack: <https://bugzilla.redhat.com/show_bug.cgi?id=1083525>
-   gnome-boxes: <https://bugzilla.gnome.org/show_bug.cgi?id=732811>

(edit 2014-09-08: This change was released in [virt-manager-1.1.0](https://blog.wikichoon.com/2014/09/virt-manager-110-released.html))
