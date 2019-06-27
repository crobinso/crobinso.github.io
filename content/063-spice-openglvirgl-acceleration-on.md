Title: spice OpenGL/virgl acceleration on Fedora 24
Date: 2016-05-22 10:56
Author: Cole Robinson
Tags: fedora, virt
Slug: spice-openglvirgl-acceleration-on
Status: published

New in Fedora 24 virt is 3D accelerated SPICE graphics, via [Virgl](https://virgil3d.github.io/). This is kinda-sorta OpenGL passthrough from the VM up to the host machine. Much of the initial support has been around since qemu 2.5, but it's more generally accessible now that SPICE is in the mix, since that's the default display type used by virt-manager and gnome-boxes.

I'll explain below how you can test things on Fedora 24, but first let's cover the hurdles and caveats. This is far from being something that can be turned on by default and there's still serious integration issues to iron out. All of this is regarding usage with libvirt tools.


### Caveats and known issues

-   This doesn't work with qemu:///system yet, which is what [virt-manager uses by default](https://blog.wikichoon.com/2016/01/qemusystem-vs-qemusession.html). Permissions and [cgroup access](https://www.redhat.com/archives/libvir-list/2016-May/msg01435.html) are problematic at the moment. qemu:///session (the gnome-boxes default) is saved from some of these issues, but it's still affected by...
-   [svirt/selinux issues](https://bugzilla.redhat.com/show_bug.cgi?id=1337333). We haven't come up with a plan here yet.
-   When enabled, your VM can't be migrated or saved (migrate to disk), either directly or as part of taking a VM snapshot
-   This only works if connecting to a VM on your local machine. And once enabled, the VM isn't accessible remotely whatsoever
-   virt-manager has some weird rendering behavior that requires [resizing the window first before you see any display output](https://bugzilla.redhat.com/show_bug.cgi?id=1337721). It's fixed upstream, but no fedora build yet. virt-viewer works fine
-   virt-manager has some [weird behavior if trying to run two GL enabled VMs at once](https://bugzilla.redhat.com/show_bug.cgi?id=1337721). Patches have been posted upstream for spice-gtk

Because of these issues, we haven't exposed this as a UI knob in any of the tools yet, to save us some redundant bug reports for the above issues from users who are just clicking a cool sounding check box :) Instead you'll need to explicitly opt in via the command line.


### Testing it out

You'll need the following packages (or later) to test this:

-   qemu-2.6.0-2.fc24
-   libvirt-1.3.3.1-2.fc24
-   virt-manager-1.3.2-4.20160520git2204de62d9.fc24
-   At least F24 beta on the host
-   Fedore 24 beta in the guest. Anything earlier is not going to actually enable the 3D acceleration. I have no idea about the state of other distributions. And to make it abundantly clear this is **linux only** and likely will be for a long time at least, I don't know if Windows driver support is even on the radar.

Once you install a Fedora 24 VM through the standard methods, you can enable spice GL for your VM with these two commands:


```console
$ virt-xml --connect $URI $VM_NAME --confirm --edit --video clearxml=yes,model=virtio,accel3d=yes
$ virt-xml --connect $URI $VM_NAME --confirm --edit --graphics clearxml=yes,type=spice,gl=on,listen=none
```


The first command will switch the graphics device to 'virtio' and enable the 3D acceleration setting. The second command will set up spice to listen locally only, and enable GL. Make sure to fully poweroff the VM afterwards for the settings to take effect. If you want to make the changes manually with '[virsh edit](https://wiki.libvirt.org/page/FAQ#Where_are_VM_config_files_stored.3F_How_do_I_edit_a_VM.27s_XML_config.3F)', the XML specifics are described in the [spice GL documentation](https://cgit.freedesktop.org/spice/spice/commit/?id=782c7508e28fdeee786cdcebffd22f772d7f09ec).

Once your VM has started up, you can verify that everything is working correctly by checking `glxinfo` output in the VM, 'virgl' should appear in the renderer string:


``` console
$ glxinfo | grep virgl
    Device: virgl (0x1010)
OpenGL renderer string: Gallium 0.4 on virgl
```


And of course the more fun test of giving supertuxkart a spin :)

Credit to Dave Airlie, Gerd Hoffman, and Marc-André Lureau for all the great work that got us to this point!
