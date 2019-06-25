Title: virt-install command line introspection
Date: 2014-02-27 14:29
Author: Cole Robinson
Tags: fedora
Slug: virt-install-command-line-introspection
Status: published

A new feature shipped with [virt-manager 1.0.0](http://blog.wikichoon.com/2014/02/virt-manager-100-released.html) is simple command line introspection for virt-install and [virt-xml](https://www.redhat.com/archives/virt-tools-list/2014-January/msg00179.html).

Basically, any of the compound options like --disk or --graphics that take sub arguments of the form opt1=val1,opt2=val2,... will print all their sub arguments if invoked like --disk=? or --graphics=help. Example:


```
 $ virt-install --disk=? --network=help
 --disk options:
  backing_store
  boot_order
  bus
  cache
  clearxml
  device
  driver_name
  driver_type
  error_policy
  format
  io
  path
  pool
  read_bytes_sec
  read_iops_sec
  readonly
  removable
  serial
  shareable
  size
  sparse
  startup_policy
  target
  total_bytes_sec
  total_iops_sec
  vol
  write_bytes_sec
  write_iops_sec

 --network options:
  boot_order
  clearxml
  driver_name
  driver_queues
  filterref
  mac
  model
  source
  source_mode
  target
  type
  virtualport_instanceid
  virtualport_managerid
  virtualport_type
  virtualport_typeid
  virtualport_typeidversion 
```


We aim to document common bits in the virt-install man page, but for less commonly used options it's better to see [the official libvirt XML documenation](http://libvirt.org/formatdomain.html).
