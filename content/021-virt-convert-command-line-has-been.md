Title: virt-convert command line has been reworked
Date: 2014-04-22 10:00
Author: Cole Robinson
Tags: fedora, virt
Slug: virt-convert-command-line-has-been
Status: published


One of the changes we made with [virt-manager 1.0](http://blog.wikichoon.com/2014/02/virt-manager-100-released.html) was a large reworking of the virt-convert command line interface.

virt-convert started life as a tool for converting back and forth between different VM configuration formats. Originally it was just between vmx and virt-image(5), but it eventually grew ovf input support. However, for the common usage of trying to convert a vmx/ovf appliance into a libvirt guest, this involved an inconvenient two step process:

* Convert to virt-image(5) with virt-convert
* Convert to a running libvirt guest with virt-image(1)

Well, since virt-image didn't really have any users, it's [planned for removal](http://blog.wikichoon.com/2014/04/deprecating-little-used-tool-virt-image1.html). So we took the opportunity to improve virt-convert in the process. Running virt-convert is now as simple as:


`virt-convert fedora18.ova`


or


`virt-convert centos6.tar.gz`


And a we convert directly to libvirt XML and launch the guest. Standard libvirt options are allowed, like --connect for specifying the libvirt driver.

The tool hasn't been heavily used and there's definitely still a lot of details we are missing, so if you hit any issues please [file a bug report.](http://virt-manager.org/bugs/)

(Long term it sounds like gnome-boxes may grow a similar feature as mentioned [over here](http://zee-nix.blogspot.com/2014/03/boxes-312.html), so maybe virt-convert isn't long for this world since there will likely be a command line interface for it as well)
