Title: Using CPU host-passthrough with virt-manager
Date: 2016-01-15 10:00
Author: Cole Robinson
Tags: fedora, virt
Slug: using-cpu-host-passthrough-with-virt
Status: published

I described virt-manager's CPU model default in [this post](https://blog.wikichoon.com/2014/03/virt-manager-improved-cpu-model-default.html). In that post I explained the difficulties of using either of the libvirt options for mirroring the host CPU: **mode=host-model** still has operational issues, and **mode=host-passthrough** isn't recommended for use with libvirt over supportability concerns.

Unfortunately since writing that post the situation hasn't improved any, and since host-passthrough is the only reliably way to expose the full capabilities of the host CPU to the VM, users regularly want to enable it. This is particularly apparent if trying to do nested virt, which often doesn't work on Intel CPUs unless host-passthrough is used.

However we don't explicitly expose this option in virt-manager since it's not generally recommended for libvirt usage. You _can_ however still enable it in virt-manager:

-   Navigate to VM Details-\>CPU
-   Enter **host-passthrough** in the CPU model field
-   Click Apply

![CPU host passthrough UI]({static}/images/061-using-cpu-host-passthrough-with-virt-1.png){width="400" height="365"}
