Title: Setting up a minimal gluster server for libvirt testing
Date: 2014-12-11 17:56
Author: Cole Robinson
Tags: fedora, virt
Slug: setting-up-minimal-gluster-server-for
Status: published

Recently I've been working on virt-install/virt-manager support for libvirt network storage pools like [gluster](https://libvirt.org/storage.html#StorageBackendGluster) and [rbd/ceph](https://libvirt.org/storage.html#StorageBackendRBD). For testing I set up a single node minimal gluster server in an F21 VM. I mostly followed the [gluster quickstart](https://www.gluster.org/community/documentation/index.php/QuickStart) and hit only a few minor hiccups.

Steps for the gluster setup:

* Cloned an existing F21 VM I had kicking around, using virt-manager's clone wizard. I called it f21-gluster.
* In the VM, disable firewalld and set selinux to permissive. Not strictly required but I wanted to make this as simple as possible.
* Setup the gluster server
    * `yum install glusterfs-server`
    * Edit /etc/glusterfs/glusterd.vol, add: `option rpc-auth-allow-insecure on`
    * `systemctl start glusterd; systemctl enable glusterd`
* Create the volume:
    * `mkdir -p /data/brick1/gv0`
    * `gluster volume create gv0 $VM_IPADDRESS:/data/brick1/gv0`
    * `gluster volume start gv0`
    * `gluster volume set gv0 allow-insecure on`
* From my host machine, I verified things were working: `sudo mount -t glusterfs $VM_IPADDRESS:/gv0 /mnt`
* I added a couple example files to the directory: a stub qcow2 file, and a boot.iso.
* Verified that qemu can access the ISO: `qemu-system-x86_64 -cdrom gluster://$VM_IPADDRESS/gv0/boot.iso`
* Once I had a working setup, I used virt-manager to create a snapshot of the running VM config. So anytime I want to test gluster, I just start the VM snapshot and I know things are all nicely setup.

The bits about 'allow-insecure' is so that an unprivileged client can access the gluster share, see [this bug](https://bugzilla.redhat.com/show_bug.cgi?id=1171436) for more info. The gluster docs also have a [section about it](https://www.gluster.org/community/documentation/index.php/Libgfapi_with_qemu_libvirt#Tuning_glusterfsd_to_accept_requests_from_QEMU) but the steps don't appear to be complete.

The final bit is setting up a storage pool with libvirt. The XML I passed to `virsh pool-define` on my host looks like:

```xml
<pool type='gluster'>
  <name>f21-gluster</name>
  <source>
    <host name='$VM_IPADDRESS'/>
    <dir path='/'/>
    <name>gv0</name>
  </source>
</pool>
```
