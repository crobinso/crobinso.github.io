Title: qemu 2.0.0 built for rawhide, but no qemu-system-aarch64 in fedora yet
Date: 2014-04-17 16:47
Author: Cole Robinson
Slug: qemu-200-built-for-rawhide-but-no-qemu
Status: published

[qemu 2.0.0](https://lists.gnu.org/archive/html/qemu-devel/2014-04/msg02734.html) was released today, and I've built it for rawhide now. Which means it will be in the [fedora-virt-preview repo](https://fedoraproject.org/wiki/Virtualization_Preview_Repository) tomorrow when my scripts pick it up (need to convert to copr one of these days...).

The 2.0 release number is fairly arbitrary here and not related to any particular feature or development. Though each qemu release tends to have some newsworthy goodies in it :)

The top highlighted change in the announcement is about qemu-system-aarch64, though it isn't built in the Fedora package yet. Right now qemu-system-aarch64 \_only\_ works on aarch64 machines, but most people that will try and give it a spin now will be trying to do aarch64 emulation on x86. So I decided not to build it yet to save myself some bug reports :)

I suspect the next qemu release will have something usable for x86 usage, so in roughly 2 months time (if things stay on schedule) when qemu 2.1 rc0 is out, I'll add the qemu-system-aarch64 sub package. This is being tracked as a 'change' for Fedora 21: <https://fedoraproject.org/wiki/Changes/Virt_64bit_ARM_on_x86>

If anyone working on Fedora aarch64 actually cares about qemu-system-aarch64 at this stage and wants it packaged up, ping me and we can talk.
