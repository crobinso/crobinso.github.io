Title: virt-manager 1.0.0 released!
Date: 2014-02-14 19:50
Author: Cole Robinson
Tags: fedora
Slug: virt-manager-100-released
Status: published

I'm happy to announce the release of virt-manager 1.0.0!

Our version numbers were starting to get awkward, and this release was suitably featureful, so it felt like time to bump the major version. (And it's trendy these days, right?).

virt-manager is a desktop application for managing KVM, Xen, and LXC virtualization via libvirt.

The release can be downloaded from:

<http://virt-manager.org/download/>

The direct download links are:

<http://virt-manager.org/download/sources/virt-manager/virt-manager-1.0.0.tar.gz>

This release includes:

- virt-manager: Snapshot support
- New tool virt-xml: Edit libvirt XML in one shot from the command line:
<http://www.redhat.com/archives/libvir-list/2014-January/msg01226.html>
- Improved defaults: qcow2, USB2, host CPU model, guest agent channel, ...
- Introspect command line options like --disk=? or --network=help
- The virt-image tool will be removed before the next release, speak up
if you have a good reason not to remove it.
- virt-manager: Support arm vexpress VM creation
- virt-manager: Add guest memory usage graphs (Thorsten Behrens)
- virt-manager: UI for editing filesystem devices (Cédric Bosdonnat)
- Spice USB redirection support (Guannan Ren)
- tpm UI and command line support (Stefan Berger)
- rng UI and command line support (Giuseppe Scrivano)
- panic UI and command line support (Chen Hanxiao)
- blkiotune command line support (Chen Hanxiao)
- virt-manager: support for glusterfs storage pools (Giuseppe Scrivano)
- cli: New options --memory, --features, --clock, --metadata, --pm
- Greatly improve app responsiveness when connecting to remote hosts
- Lots of UI cleanup and improvements

Over the next few weeks I'll be on writing a bit more in depth about some of the above changes.
