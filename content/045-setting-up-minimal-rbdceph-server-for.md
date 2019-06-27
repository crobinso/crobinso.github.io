Title: Setting up a minimal rbd/ceph server for libvirt testing
Date: 2014-12-15 11:21
Author: Cole Robinson
Tags: fedora, virt
Slug: setting-up-minimal-rbdceph-server-for
Status: published

In my [last post](https://blog.wikichoon.com/2014/12/setting-up-minimal-gluster-server-for.html) I talked about setting up a minimal gluster server. Similarly this will describe how I set up a minimal single node rbd/ceph server in a VM for libvirt network storage testing.

I pulled info from a [few](https://eu.ceph.com/docs/wip-6919/start/quick-start/) [different](https://derekweitzel.blogspot.com/2012/02/ceph-on-fedora-16.html) [places](https://dachary.org/?p=2374) and a lot of other reading, but things just weren't working on F21; trying `systemctl start ceph` just wasn't producing any output, and all the `ceph` cli commands just hung. I had better success with F20.

The main difficulty was figuring out a working ceph.conf. My VM's IP address is 1902.168.124.101, and its hostname is 'localceph', so here's what I ended up with:


```ini
[global]
auth cluster required = none
auth service required = none
auth client required = none
osd crush chooseleaf type = 0
osd pool default size = 1

[mon]
mon data = /data/$name
[mon.0]
mon addr = 192.168.124.101
host = localceph

[mds]
keyring = /data/keyring.$name
[mds.0]
host = localceph

[osd]
osd data = /data/$name
osd journal = /data/$name/journal
osd journal size = 1000
[osd.0]
host = localceph
```


Ceph setup steps:

* Cloned an existing F20 VM I had kicking around, using virt-manager's clone wizard. I called it f20-ceph.
* In the VM, disable firewalld and set selinux to permissive. Not strictly required but I wanted to make this as simple as possible.
* Setup the ceph server:
    * `yum install ceph`
    * I needed to set a hostname for my VM, ceph won't accept 'localhost': `hostnamectl set-hostname localceph`
    * `mkdir -p /data/mon.0 /data/osd.0`
    * Overwrite /etc/ceph/ceph.conf with the content listed above.
    * `mkcephfs -a -c /etc/ceph/ceph.conf`
    * `service ceph start`
    * Prove it works from my host with: `sudo mount -t ceph $VM_IPADDRESS:/ /mnt`
* Add some storage for testing:
    * Libvirt only connects to Ceph's block device interface, RBD. The above mount example is _not_ what libvirt will see, it just proves we can talk to the server.
    * Import files within the VM like: `rbd import $filename`
    * List files with: `rbd list`

Notable here is that no ceph auth is used. Libvirt supports ceph auth but at this stage I didn't want to deal with it for testing. This setup doesn't match what a real deployment would ever look like.

Here's the pool definition I passed to `virsh pool-define` on my host:

```xml
<pool type='rbd'>
  <name>f20-ceph</name>
  <source>
    <host name='$VM_IPADDRESS'/>
    <name>rbd</name>
  </source>
</pool>
```
