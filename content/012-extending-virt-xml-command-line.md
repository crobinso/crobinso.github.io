Title: Extending the virt-xml command line
Date: 2014-03-10 18:03
Author: Cole Robinson
Tags: fedora, virt
Slug: extending-virt-xml-command-line
Status: published

Edit May 2019: This tutorial is out of date. A modern version is on the virt-manager github wiki: <https://github.com/virt-manager/virt-manager/wiki/Extending-the-command-line>

As [previously explained](http://blog.wikichoon.com/2014/03/virt-xml-edit-libvirt-xml-from-command.html), virt-manager 1.0.0 shipped with a tool called virt-xml, which enables editing libvirt XML from the command line in one shot. This post will walk through an example of patching virt-xml to support a new libvirt XML value.

A bit of background: libvirt VM configuration is in XML format. It [has quite an extensive XML schema](http://libvirt.org/formatdomain.html). For QEMU/KVM guests, most of the XML attributes map to qemu command line values. QEMU is always adding new emulated hardware and new features, which in turn require the XML schema to be extended. Example: this [recent libvirt change](http://libvirt.org/git/?p=libvirt.git;a=commit;h=08d07e5fd8a4c072bf040b3949bbd969f98d1081) to allow turning off Spice drag + drop support with a `<filetransfer enable='no'/\>` option.

For this example, we are going to expose a different property: defaultMode, also part of the graphics device. defaultMode can be used to tell qemu to open all spice channels in secure TLS mode. But for the purpose of this example, what defaultMode actually does and how it works isn't important. For virt-xml, the only important bit is getting the value for the command line, writing it correctly as XML, and unit testing the XML generation.

You can see the completed virt-xml git commit [over here](https://github.com/virt-manager/virt-manager/commit/b4e4f683761c55259bd5ed4b3c5549568d6147bb).



**Step 0: Run the test suite**

The virt-manager test suite aims to always 100% pass, but depending on your host libvirt version things can occasionally be broken. Run 'python setup.py test' and note if any tests fail. The important bit here is that after we make all the following changes, the test suite shouldn't regress at all.


**Step 1: XML generation**


```diff
diff --git a/virtinst/devicegraphics.py b/virtinst/devicegraphics.py
index 37f268a..a87b71c 100644
--- a/virtinst/devicegraphics.py
+++ b/virtinst/devicegraphics.py
@@ -204,6 +204,7 @@ class VirtualGraphics(VirtualDevice):
   passwdValidTo = XMLProperty("./@passwdValidTo")
   socket = XMLProperty("./@socket")
   connected = XMLProperty("./@connected")
+  defaultMode = XMLProperty("./@defaultMode")

   listens = XMLChildProperty(_GraphicsListen)
   def remove_listen(self, obj):
```


Starting with [virt-manager git](https://github.com/virt-manager/virt-manager), first we extend the internal API to map a python class property to its associated XML value.

The virtinst/ directory contains the internal XML building API used by all the tools shipped with virt-manager. There's generally a single file and class per XML object, examples

-   devicegraphics.py: `<graphics\>` device
-   cpu.py: `<cpu\>` block
-   osxml.py: `<os\>` block
-   And so on

If you aren't sure what file or class you need to alter, try grepping for a property you know that virt-install already supports. So, for example, using [virt-install --graphics=?](http://blog.wikichoon.com/2014/02/virt-install-command-line-introspection.html) I see that there's a property named passwdValidTo. Doing 'git grep passwdValidTo' will point to virtinst/devicegraphics.py

'XMLProperty' is some custom glue that maps a python class property to an XML value, for both reading and writing. The value passed to XMLProperty is an XML xpath. If you don't know how xpaths work, google around, or try to find an existing example in the virtinst code.

Notice that this doesn't do much else, like validate that the value passed to defaultMode is actually valid. The general rule is to leave this up to libvirt to complain.


**Step 2: Command line handling**


```diff
diff --git a/virtinst/cli.py b/virtinst/cli.py
index 826663a..41d6a8c 100644
--- a/virtinst/cli.py
+++ b/virtinst/cli.py
@@ -1810,6 +1810,7 @@ class ParserGraphics(VirtCLIParser):
     self.set_param("passwd", "password")
     self.set_param("passwdValidTo", "passwordvalidto")
     self.set_param("connected", "connected")
+    self.set_param("defaultMode", "defaultMode")

   def _parse(self, opts, inst):
     if opts.fullopts == "none":
```


The next step is to set up command line handling. In this case we are adding a sub option to the --graphics command. Open up virtinst/cli.py and search for '--graphics', you'll find a comment with a ParserGraphics class defined after it. That's where we plug in new sub options.

The 'self.set\_param' registers the sub option: first argument is the name on the cli, second argument is the property name we defined above. In this case they are the same.

Some options do extra validation or need to do special handling. If you need extra functionality, look at examples that pass setter\_cb to set\_param.

After this bit is applied, you'll see defaultMode appear in the --graphics=? output, and everything will work as expected. But we need to add a unit test to validate the XML generation.

An easy way to test that this is working is with a command line like:


```
./virt-install --connect test:///default --name foo --ram 64
              --nodisks --boot network --print-xml
              --graphics spice,defaultMode=secure
```


That will use libvirt's 'test' driver, which is made for unit testing, and doesn't affect the host at all. The --print-xml command will output the new XML. Verify that your new command line option works as expected before continuing. See the [HACKING](https://github.com/virt-manager/virt-manager/blob/master/HACKING) file for additional tips for using the test driver.


**Step 3: Unit test XML generation**


```diff
diff --git a/tests/xmlparse.py b/tests/xmlparse.py
index a2448d2..397da45 100644
--- a/tests/xmlparse.py
+++ b/tests/xmlparse.py
@@ -559,6 +559,7 @@ class XMLParseTest(unittest.TestCase):
     check("channel_cursor_mode", "any", "any")
     check("channel_playback_mode", "any", "insecure")
     check("passwdValidTo", "2010-04-09T15:51:00", "2011-01-07T19:08:00")
+    check("defaultMode", None, "secure")

     self._alter_compare(guest.get_xml_config(), outfile)
```


tests/xmlparse.py tests reading and writing, so it will test the change we made in virtinst/devicegraphics.py. Before you make any tests/, run 'python setup.py test --testfile xmlparse.py', you should see a new error: this is because xmlparse.py will emit a test failure if a new XML property in virtinst/ that isn't explicitly tested!

Similar to how you found what virtinst/ file to edit by grepping for a known graphics property like passwdValidTo, do the same in xmlparse.py to find the pre-existing graphics test function. The check() invocation is a small wrapper for setting and reading a value: the first argument is the python property name we are poking, the second argument is what the initial value should be, and the final argument is the new value we are setting.

The initial XML comes from tests/xmlparse-xml/\*, and is initialized at the start of the function. But in our case, we don't need to manually alter that. So make the change, and rerun 'python setup.py test --testfile xmlparse.py' and...

Things broke! That's because the generated XML output changed, and contains our new defaultMode value. So we need to update the known-good XML files we compare against. The easiest way to do that is to run 'python setup.py test --testfile xmlparse.py --regenerate-output'. Run 'git diff' afterwards to ensure that only the graphics file was changed.

Finally, run 'python setup.py test' and ensure the rest of the test suite doesn't regress compared to the initial run you did in Step 0.

For cases where you added non-trivial command line handling, take a look at tests/clitest.py, where we run a battery of command line parsing tests. You likely want to extend this to verify your command line works as expected.

Also, if you want to add an entirely new command line option that maps to an XML block, [this commit adding the --memtune option](https://github.com/virt-manager/virt-manager/commit/94744bce20ec88a7a83c5e7af23dac5d5b0fae10) is a good reference.


**Step 4) Documentation?**

For each new option sub property, the general rule is we don't need to explicitly list it in the man page or virt-install/virt-xml --help output. The idea is that command line introspection and libvirt XML documentation should be sufficient. However, if your command line option has some special behavior, or is particularly important, consider extending man/virt-install.pod.


**Step 5) Submit the patch!**

So your patch is done! git commit -a && git send-email -1 --to virt-tools-list@redhat.com or simply drop it in a [bug report](http://virt-manager.org/bugs/). If you have any questions or need any assitance, [drop us a line](http://virt-manager.org/communicate/).


(update 2015-09-04: Point git links to github)
