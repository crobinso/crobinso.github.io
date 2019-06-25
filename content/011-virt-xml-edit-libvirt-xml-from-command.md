Title: virt-xml: Edit libvirt XML from the command line
Date: 2014-03-04 09:00
Author: Cole Robinson
Tags: fedora, virt
Slug: virt-xml-edit-libvirt-xml-from-command
Status: published

We shipped a new tool with [virt-manager 1.0.0](http://blog.wikichoon.com/2014/02/virt-manager-100-released.html) called [virt-xml](https://www.redhat.com/archives/virt-tools-list/2014-January/msg00179.html). virt-xml uses virt-install's command line options to allow building and editing libvirt domain XML. A few basic examples:

Change the `<description\>` of domain 'example':

```
# virt-xml example --edit --metadata description="my new description"
```


Enable the boot device menu for domain 'example':

```
# virt-xml example --edit --boot bootmenu=on
```


Hotplug host USB device 001.003 to running domain 'fedora19':

```
# virt-xml f19 --add-device --host-device 001.003 --update
```


The [virt-xml man page](https://git.fedorahosted.org/cgit/virt-manager.git/tree/man/virt-xml.pod) also has a comprehensive set of examples.

While I doubt anyone would call it sexy, virt-xml fills a real need in the libvirt ecosystem. Prior to virt-xml, a question like 'how do I change the cache mode for my VM disk' had two possible answers:

**1) Use 'virsh edit'**

'virsh edit' drops you into $EDITOR and allows you to edit the XML manually. Now ignoring the fact that editing XML by hand is a pain, 'virsh edit' requires the user to know the exact XML attribute or property name, and where to put it. And if its in the wrong place or mis-named, in most cases libvirt will happily ignore it with no feedback (this is actually useful at the API level but not very friendly for direct user interaction).

But more than that, have you ever seen what happens when you drop a less than savvy user into vim for the first time? It doesn't end well :) And this happens more than you might expect.

**2) Use virt-manager**

The more newbie friendly option for sure, the UI is intuitive enough that people can usually find the XML bit they want to twiddle... provided it actually exists in virt-manager.

And that's the problem: over time these types of requests put pressure on virt-manager to expose many kind-of-obscure-but-not-so-obscure-that-virsh-edit-is-an-acceptable-answer XML properties in the UI. It was unclear where to draw the line on what should be in the UI and what shouldn't, and we ended up with various UI bits that very few people were actually interacting with.

**Enter virt-xml**

So here's virt-xml, that allows us to easily make these types of XML changes with a single command. This takes the pressure off virt-manager, and provides a friendly middle ground between the GUI and 'virsh edit'. It also greatly simplifies documentation and wiki pages (like fedora test day test cases).

The CLI API surface is huge compared to virt-manager's UI. There's no reason that virt-xml can't expand to support every XML property exposed by libvirt. And we've worked on making it trivially easy to to extend the tool to handle new XML options: in many cases, it's only [**3 lines of code**](http://blog.wikichoon.com/2014/03/extending-virt-xml-command-line.html) to add a new --disk/--network/... sub option, including unit testing, [command line introspection](http://blog.wikichoon.com/2014/02/virt-install-command-line-introspection.html), and virt-install support.
