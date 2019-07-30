Title: UEFI support in virt-install and virt-manager
Date: 2016-01-02 17:19
Author: Cole Robinson
Tags: fedora, virt
Slug: uefi-support-in-virt-install-and-virt
Status: published

One of the new features in [virt-manager 1.2.0](https://blog.wikichoon.com/2015/05/virt-manager-120-released.html) (from back in May) is user friendly support for enabling UEFI.

First a bit about terminology: When UEFI is packaged up to run in an x86 VM, it's often called **OVMF**. When UEFI is packaged up to run in an AArch64 VM, it's often called **AAVMF**. But I'll just refer to all of it as UEFI.


#### Using UEFI with virt-install and virt-manager

The first step to enable this for VMs is to install the binaries. UEFI still has some [licensing issues](https://fedoraproject.org/wiki/Using_UEFI_with_QEMU#EDK2_Licensing_Issues) that make it incompatible with Fedora's policies, so the bits are hosted in an external repo. Details for installing the repo and UEFI bits are [over here](https://fedoraproject.org/wiki/Using_UEFI_with_QEMU#Firmware_installation).

(Edit: those licensing issues were resolved and now the packages are [natively available in Fedora repos](http://localhost:8000/2016/06/uefi-virt-support-now-in-official.html))

Once the bits are installed (and you're on Fedora 22 or later), virt-manager and virt-install provide simple options to enable UEFI when creating VMs.

[Marcin has a great post](https://marcin.juszkiewicz.com.pl/2015/04/17/running-vms-on-fedoraaarch64/) with screenshots describing this for virt-manager (for aarch64, but the steps are identical for x86 VMs).

For virt-install it's as simple as doing: `sudo virt-install --boot uefi ...`

virt-install will get the binary paths from libvirt and set everything up with the optimal config. If virt-install can't figure out the correct parameters, like if no UEFI binaries are installed, you'll see an error like: `ERROR    Error: --boot uefi: Don't know how to setup UEFI for arch 'x86'`

See `virt-install --boot help` if you need to tweak the parameters individually.


#### Implementing support in applications

Libvirt needs to know about UEFI to NVRAM config file mapping, so it can advertise it to tools like virt-manager/virt-install. Libvirt looks at a hardcoded list of known host paths to see if any firmware is installed, and if so, lists those paths in domain capabilities output (`virsh domcapabilities`). Libvirt in Fedora 22+ knows to look for the paths provided by the repo mentioned above, so just installing the firmware is sufficient to make libvirt advertise UEFI support.

The domain capabilities output only lists the firmware path and the associated variable store path. Notably lacking is any indication of what architecture the binaries are meant for. So tools need to determine this mapping themselves.

virt-manager/virt-install and libguestfs use a similar path matching heuristic. The [libguestfs code](https://github.com/libguestfs/libguestfs/blob/master/v2v/utils.ml#L89) is a good reference:


```ocaml
match guest_arch with
| "i386" | "i486" | "i586" | "i686" ->
   [ "/usr/share/edk2.git/ovmf-ia32/OVMF_CODE-pure-efi.fd",
     "/usr/share/edk2.git/ovmf-ia32/OVMF_VARS-pure-efi.fd" ]
| "x86_64" ->
   [ "/usr/share/OVMF/OVMF_CODE.fd",
     "/usr/share/OVMF/OVMF_VARS.fd";
     "/usr/share/edk2.git/ovmf-x64/OVMF_CODE-pure-efi.fd",
     "/usr/share/edk2.git/ovmf-x64/OVMF_VARS-pure-efi.fd" ]
| "aarch64" ->
   [ "/usr/share/AAVMF/AAVMF_CODE.fd",
     "/usr/share/AAVMF/AAVMF_VARS.fd";
     "/usr/share/edk2.git/aarch64/QEMU_EFI-pflash.raw",
     "/usr/share/edk2.git/aarch64/vars-template-pflash.raw" ]
| arch ->
   error (f_"don't know how to convert UEFI guests for architecture %s")
         guest_arch in
```


Having to track this in every app is quite crappy, but it's the only good solution at the moment. Hopefully long term libvirt [will grow some solution](https://bugzilla.redhat.com/show_bug.cgi?id=1295146) that makes this easier for applications.
