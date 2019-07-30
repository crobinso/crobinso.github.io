Title: Deprecating little used tool virt-image(1)
Date: 2014-04-15 10:00
Author: Cole Robinson
Tags: fedora, virt
Slug: deprecating-little-used-tool-virt-image1
Status: published

(edit 2014-09-08: virt-image was removed in [virt-manager-1.1.0](https://blog.wikichoon.com/2014/09/virt-manager-110-released.html))

In the recent [virt-manager 1.0 release](https://blog.wikichoon.com/2014/02/virt-manager-100-released.html), we've taken a step towards deprecating one of the command line tools we ship, [virt-image(1)](https://linux.die.net/man/1/virt-image). This shouldn't have any real end user effect because I'm pretty sure near zero people are using it.

virt-image [was created](https://www.redhat.com/archives/et-mgmt-tools/2007-June/msg00076.html) in June 2007 as an [XML schema](https://linux.die.net/man/5/virt-image) and command line tool for distributing VM images as appliances. The format would describe the fundamental needs of a VM image, like how many disk devices it wants, but leave the individual configuration details up to the user. The virt-image(1) tool would take the XML as input and kick off a libvirt VM.

While the idea was reasonable, the XML format would only be useful if people actually used it, which never happened. All desktop VM appliance usage nowadays is shipped with native VMWare config as .vmx files, or with .ovf configuration.

In the past, [appliance-tools](https://git.fedorahosted.org/cgit/appliance-tools.git/) generated virt-image XML, but that was dropped. Same with [boxgrinder](https://boxgrinder.org/).

But most users of it in the past few years have been way of the (also little used) virt-convert tool that we ship with virt-manager (which I'll cover in a later post). Historically virt-convert would output virt-image XML by default. Well, that too was changed in 1.0: virt-convert generates direct libvirt XML now. This makes virt-convert more convenient, and left us with no good reason to keep virt-image around anymore.

So the plan is to drop virt-image before the next major release of virt-manager. Likely sometime in the next 6 months.
