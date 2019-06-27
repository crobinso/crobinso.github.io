Title: x2apic on by default with qemu 2.0+, and some history
Date: 2014-11-28 14:37
Author: Cole Robinson
Tags: fedora, virt
Slug: x2apic-on-by-default-with-qemu-20-and
Status: published

[x2apic](https://en.wikipedia.org/wiki/X2APIC) is a performance and scalability feature available in many modern Intel CPUs. Though regardless of whether your host CPU supports it, KVM can unconditionally emulate it for x86 guests, giving an easy performance win with no downside. This feature has existed since 2009 and been a regular recommendation for [tuning a KVM VM](https://www.linux-kvm.org/page/Tuning_KVM).

As of qemu 2.0.0 x2apic is enabled automatically (more details at the end).
Priot to that, actually benefiting from x2apic required a tool like virt-manager to explicitly enable the flag, which has had a long bumpy road.

x2apic is exposed on the qemu command line as a CPU feature, like: `qemu -cpu $MODEL,+x2apic ...`

And there isn't any way to specify a feature flag without specifying the CPU model. So enabling x2apic required hardcoding a CPU model where traditionally tools (and libvirt) deferred to qemu's default.

A Fedora 13 [feature page](https://fedoraproject.org/wiki/Features/Virtx2apic) was created to track the change, and we [enabled it in python-virtinst](https://pkgs.fedoraproject.org/cgit/python-virtinst.git/commit/?id=7a684cb65d69f2b116809456bed99ed32ca44080) for f13/rawhide. The implementation attempted to hardcode the CPU model name that libvirt detected for the host machine, which unfortunately has some problems as I explained in a [previous post](https://blog.wikichoon.com/2014/03/virt-manager-improved-cpu-model-default.html). This led to some [issues](https://bugzilla.redhat.com/show_bug.cgi?id=611584) installing 64bit guests, and after trying to hack around it, I gave up and reverted the change.

(In retrospect, we likely could have made it work by just trying to duplicate the default CPU model logic that qemu uses, however that might have hit issues if the CPU default ever changed, like on RHEL for example.)

Later on virt-manager and virt-install gained UI for enabling x2apic, but a user had to know what they were doing and hunt it down.

As mentioned above, as of qemu 2.0.0 any x86 KVM VM will have x2apic automatically enabled, so there's no explicit need to opt in. From qemu.git:

```
commit ef02ef5f4536dba090b12360a6c862ef0e57e3bc
Author: Eduardo Habkost <ehabkost redhat.com>
Date:   Wed Feb 19 11:58:12 2014 -0300

    target-i386: Enable x2apic by default on KVM
```
