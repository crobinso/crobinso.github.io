Title: qemu-system-x86_64: error while loading shared libraries: libGL.so.1: failed to map segment from shared object: Permission denied
Date: 2013-11-19 15:56
Author: Cole Robinson
Tags: fedora
Slug: qemu-system-x8664-error-while-loading
Status: published

Are you getting this error when trying to start a libvirt KVM VM on Fedora 20?

> qemu-system-x86_64: error while loading shared libraries: libGL.so.1: failed to map segment from shared object: Permission denied

Seems to be caused by Nvidia proprietary drivers. Whatever black magic they are doing behind the scenes is upsetting the selinux restrictions qemu is run under.

The fix: `sudo setsebool -P virt_use_execmem=on`

(update Jan 2016: the original bug that prompted this post had some follow up discussion about a possible cause, so maybe it's fixable: <https://bugzilla.redhat.com/show_bug.cgi?id=966695>)
