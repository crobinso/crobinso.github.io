Title: A brief-ish history of virtinst and virt-install
Date: 2014-05-06 10:00
Author: Cole Robinson
Tags: fedora, virt
Slug: a-brief-ish-history-of-virtinst-and
Status: published

[virt-install](http://linux.die.net/man/1/virt-install) is a command line tool for creating new virtual machines via libvirt. It's an important piece of the libvirt ecosystem that has shipped in RHEL5.0 and up, and over a dozen Fedora versions.

It wasn't always called virt-install though: it started life as xenguest-install.py written by [Jeremy Katz](http://velohacker.com/). I think it was just an internal Red Hat only thing for a brief period, until it first surfaced as part of the Fedora 'xen' package in [January 2006](http://pkgs.fedoraproject.org/cgit/xen.git/commit/?id=02687b4e3f7fa0db5de34280a2cb7e1a8eb8ff18):


```git
commit 02687b4e3f7fa0db5de34280a2cb7e1a8eb8ff18
Author: Stephen Tweedie <sct@fedoraproject.org>
Date:  Tue Jan 31 16:59:19 2006 +0000

  Add xenguest-install.py in /usr/sbin
```


(Strangely, the file isn't actually in git... I assume this is some accident of the CVS-\>git conversion. You can see the version shipped with Fedora Core 5 in the [archived RPM](https://archives.fedoraproject.org/pub/archive/fedora/linux/core/5/x86_64/os/Fedora/RPMS/xen-3.0.1-4.x86_64.rpm)).

Check out the original set of arguments

```
Options:
 -h, --help      show this help message and exit
 -n NAME, --name=NAME Name of the guest instance
 -f DISKFILE, --file=DISKFILE
            File to use as the disk image
 -s DISKSIZE, --file-size=DISKSIZE
            Size of the disk image (if it doesn't exist) in
            gigabytes
 -r MEMORY, --ram=MEMORY
            Memory to allocate for guest instance in megabytes
 -m MAC, --mac=MAC   Fixed MAC address for the guest; if none is given a
            random address will be used
 -v, --hvm       This guest should be a fully virtualized guest
 -c CDROM, --cdrom=CDROM
            File to use a virtual CD-ROM device for fully
            virtualized guests
 -p, --paravirt    This guest should be a paravirtualized guest
 -l LOCATION, --location=LOCATION
            Installation source for paravirtualized guest (eg,
            nfs:host:/path, http://host/path, ftp://host/path)
 -x EXTRA, --extra-args=EXTRA
            Additional arguments to pass to the installer with
            paravirt guests
```

All those bits are still working with virt-install today, although many are are deprecated and hidden from the --help output by default.

In early 2006, libvirt barely even existed, so the xenguest-install.py was generating [xen xm](http://wiki.xen.org/wiki/Xen_Configuration_File_Options) config files (basically just raw python code) in /etc/xen.
Fedora CVS was the canonical home of the script.

In March 2006, [Dan Berrangé](http://berrange.com/) [started work on virt-manager](https://git.fedorahosted.org/cgit/virt-manager.git/commit/?id=3ed0ef3). It was very briefly called gnome-vm-manager, then settled into gnome-virt-manager until July 2006 when it was [renamed to virt-manager](https://git.fedorahosted.org/cgit/virt-manager.git/commit/?id=dc0d6db84cfe78c4a479381ead55bbd83c0cca55).

In August 2006, xenguest-install moved to its own repo, [python-xeninst](https://git.fedorahosted.org/cgit/python-virtinst.git/commit/?id=1e2e1aa0ca0b5ed8669be61aa4271a3e8c1d7333):


```git
commit 1e2e1aa0ca0b5ed8669be61aa4271a3e8c1d7333
Author: Jeremy Katz <katzj@redhat.com>
Date:  Tue Aug 8 21:37:49 2006 -0400

  first pass at breaking up xenguest-install to have more of a usable API.
  currently only works for paravirt and some of the bits after the install
  gets started are still a little less than ideal
```


Much of logic was moved to a 'xeninst' module. There were some initial bits for generating libvirt XML, but the primary usage was still generating native xen configuration.

(Both repositories were hosted in mercurial at hg.et.redhat.com for many years. We eventually [transitioned to git in March 2011](http://www.redhat.com/archives/virt-tools-list/2011-March/msg00056.html). Actually it's amazing it was only 3 years ago: I've pretty much entirely forgotten how to use mercurial despite using it for 4 years prior.)

In October 2006, the project was [renamed python-virtinst](https://git.fedorahosted.org/cgit/python-virtinst.git/commit/?id=761ccd8a65a79737431aa1415d16b19ef9d8f9c8) and the tool renamed to virt-install. By this point virt-manager was using the xeninst module for guest creation and needed to [handle the rename](https://git.fedorahosted.org/cgit/virt-manager.git/commit/?id=cd946bcfae2960c4769c5f12e235d1026a33328d) as well.

So now python-virtinst was its own standalone package, providing virt-install and a python library named virtinst. Over the next couple years the repo accumulated a few more tools: [virt-clone in May 2007](https://git.fedorahosted.org/cgit/python-virtinst.git/commit/?id=bfa6c18f94fdb9d30c30df494e4b338745e79f5e), [virt-image in June 2007](https://git.fedorahosted.org/cgit/python-virtinst.git/commit/?id=c4d45ff7960bd84050bb382d597dc3cfdf3d3882), and [virt-convert (originally virt-unpack) in July 2008](https://git.fedorahosted.org/cgit/python-virtinst.git/commit/?id=a0401fe359af0220ea3e609861042ad9f000d7d5).

However over the next few years we had some growing pains with the virtinst module. It wasn't exactly a planned API, rather a collection of code that grew organically from a quick hack of a script. It never received too much thought for future compatibility. The fact that it ended up as a public API was more historic accident than anything. Once we accumulated external users ([cobbler in March 2007](https://github.com/cobbler/cobbler/commit/dd569b1834e9611b8390d334e2016b0659253e72) and [koji in July 2010](https://git.fedorahosted.org/cgit/koji/commit/?id=64cc01be898547d150f0200111ff0e57176ecdd7)) we were stuck with the API in the name of back compatibility.

Then there was the general frustration of doing virt-manager development when it evolved in lockstep with virtinst: running upstream virt-manager always required running up to date python-virtinst, which was a barrier to upstream contribution.

So in February 2012 I layed out some reasons for [dropping virtinst as a public API and merging the code into virt-manager.git](http://www.redhat.com/archives/virt-tools-list/2012-February/msg00040.html), though it didn't fully happen until [april 2013 during the virt-manager 0.10.0 cycle](https://www.redhat.com/archives/virt-tools-list/2013-April/msg00026.html). In the intervening year, I sent patches to koan and koji to move off virtinst to calling the needed virt-\* tool directly.

So nowadays virtinst, virt-install, etc. all live with virt-manager.git. If you're looking for a library that helps handle libvirt XML or create libvirt VMs, check out [libvirt-designer](http://libvirt.org/git/?p=libvirt-designer.git;a=summary) and [libvirt-gobject/libvirt-gconfig](http://libvirt.org/git/?p=libvirt-glib.git;a=summary).
