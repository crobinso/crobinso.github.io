Title: virt-manager 1.0: reduced polling and CPU usage
Date: 2014-05-13 10:00
Author: Cole Robinson
Tags: fedora, virt
Slug: virt-manager-10-reduced-polling-and-cpu
Status: published

A lot of work was done for [virt-manager 1.0](https://blog.wikichoon.com/2014/02/virt-manager-100-released.html) to reduce the amount of libvirt polling and API calls we make for common operations. Up until this point, virt-manager had to poll libvirt at regular intervals to update the domain list, domain status, and domain XML. By default we would poll once a second (configurable in the Preferences dialog).

Although this burned far more CPU than necessary, things generally worked fine when talking to libvirtd on the local machine. However things really fell apart when connecting to a remote host with a lot of VMs, or over a high latency link: the polling would just saturate the connection and the app would be quite sluggish. Since the latter scenario is a pretty common setup for some of my remote colleagues at Red Hat, I heard about this quite a bit over the years :)

One of the major hurdles to reducing needless polling was that virt-manager and virtinst were separate code bases, as I explained in a [previous post](https://blog.wikichoon.com/2014/05/a-not-so-brief-history-of-virtinst-and.html). For example, there is one routine in virtinst that will check if a new disk path is already in use by another VM: it does this by checking the path against the XML of every VM. Since virtinst was separate code, it had to do all this polling and XML fetching from scratch, despite the fact that we had this information cached in virt-manager. We could have taught virtinst about the virt-manager cache or some similar solution, but it was cumbersome to make changes like that while maintaining back compatibility with older virtinst users.

Well, with virt-manager 0.10.0 we deprecated the public virtinst API and merged the code into virt-manager git. This allowed us to do a ton of code cleanup and simplification during the virt-manager 1.0 cycle to remove much of the API spamming.

The other major piece we added in virt-manager 1.0 is use of asynchronous libvirt events. The initial events support in libvirt was [added way back in October 2008](https://libvirt.org/git/?p=libvirt.git;a=commit;h=1509b8027fd0b73c30aeab443f81dd5a18d80544) by a couple folks from [VirtualIron](https://en.wikipedia.org/wiki/Virtual_Iron). That's quite a while ago, so supporting this in virt-manager was long overdue. Though waiting a long time had the nice side effect of letting other projects like oVirt shake all the bugs out of libvirt's event implementations :)

Regardless, virt-manager 1.0 will use domain (and network) events now if connected to a sufficiently new version of libvirt and the driver supports it. We still maintain the old polling code for really old libvirt, and libvirt drivers that don't support the event APIs. Even on latest libvirt some polling is still needed since not all libvirt objects support event APIs, although now we poll on demand which reduces our CPU and network usage.
