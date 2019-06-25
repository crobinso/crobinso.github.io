Title: Easy qemu commandline passthrough with virt-xml
Date: 2017-03-24 21:30
Author: Cole Robinson
Tags: fedora, virt
Slug: easy-qemu-commandline-passthrough-with
Status: published

Libvirt has supported [qemu commandline option passthrough](https://libvirt.org/drvqemu.html#qemucommand) for qemu/kvm VMs for quite a while. The format for it is a bit of a pain though since it requires setting a magic xmlns value at the top of the domain XML. Basically doing it by hand kinda sucks.

In the recently released [virt-manager 1.4.1](http://blog.wikichoon.com/2017/03/virt-manager-141-released.html), we added a virt-install/virt-xml option **--qemu-commandline** that tweaks option passthrough for new or existing VMs. So for example, if you wanted to add the qemu option string '-device FOO' to an existing VM named **f25**, you can do:


```diff
$ ./virt-xml f25 --edit --confirm --qemu-commandline="-device FOO"

--- Original XML
+++ Altered XML
@@ -1,4 +1,4 @@
-<domain type="kvm">
+<domain xmlns:qemu="http://libvirt.org/schemas/domain/qemu/1.0" type="kvm">
   <name>f25</name>
   <uuid>9b6f1795-c88b-452a-a54c-f8579ddc18dd</uuid>
   <memory unit="KiB">4194304</memory>
@@ -104,4 +104,8 @@
       <address type="pci" domain="0x0000" bus="0x00" slot="0x0a" function="0x0"/>
     </rng>
   </devices>
+  <qemu:commandline>
+    <qemu:arg value="-device"/>
+    <qemu:arg value="foo"/>
+  </qemu:commandline>
 </domain>

Define 'f25' with the changed XML? (y/n):
```
