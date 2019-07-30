Title: Host 'Network Interfaces' panel removed from virt-manager
Date: 2019-04-09 14:01
Author: Cole Robinson
Tags: fedora, virt
Slug: host-network-interfaces-panel-removed
Status: published

I released [virt-manager 2.0.0](https://www.redhat.com/archives/virt-tools-list/2018-October/msg00087.html) in October 2018. Since the release contained the full port to python3, it seemed like a good opportunity to drop some baggage from the app.

The biggest piece we removed was the UI for managing host network interfaces. This is the **Connection Details->Network Interfaces** panel, and the **New Interface** wizard for defining host network definitions for things like bridges, bonds, and vlan devices. The main screen of the old UI looked like this:


![virt-manager host interfaces panel]({static}/images/074-host-network-interfaces-panel-removed-1.png){width="400" height="280"}


#### Some history

Behind the scenes, this UI was using libvirt's Interface APIs, which also power the `virsh iface-*` commands. These APIs are little more than a wrapper around the [netcf](https://pagure.io/netcf) library.

netcf aimed to be a linux distro independent API for network device configuration. On Red Hat distros this meant turning the API's XML format into an `/etc/sysconfig/network` script. There were even pie-in-the-sky ideas about NetworkManager one day using netcf.

In practice though the library never really took off. It was years before a debian backend showed up, contributed by a Red Hatter in the hope of increasing library uptake, though it didn't seem to help. netcf basically only existed to serve the libvirt Interface APIs, yet those APIs were never really used by any major libvirt consuming app, besides virt-manager. And in virt-manager's case it was largely just slapping some UI over the XML format and lifecycle operations.

For virt-manager's usecases we hoped that netcf would make it trivial to bridge the host's network interface, which when used with VMs would give them first class IP addresses on the host network setup, not NAT like the 'default' virtual network. Unfortunately though the UI would create the ifcfg files well enough, behind the scenes nothing played well with NetworkManager for years and years. The standard suggestion for was to disable NetworkManager if you wanted to bridge your host NIC. Not very user friendly. Some people did manage to use the UI to that effect but it was never a trivial process.

#### The state today

Nowadays NetworkManager can handle bridging natively and is much more powerful than what virt-manager/libvirt/netcf provide. The virt-manager UI was more likely to shoot you in the foot than make things simple. And it had become increasingly clear that virt-manager was not the place to maintain host network config UI.

So we made the decision to drop all this from virt-manager in 2.0.0. netcf and the libvirt interface APIs still exist. If you're interested in some more history on the interface API/netcf difficulties, check out [Laine's email](https://www.redhat.com/archives/virt-tools-list/2018-October/msg00049.html) to virt-tools-list.
