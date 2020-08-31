Title: virt-manager libvirt XML editor UI
Date: 2020-07-12
Author: Cole Robinson
Tags: fedora,virt
Slug: virt-manager-xml-editor
Status: published

[virt-manager 2.2.0](https://www.redhat.com/archives/virt-tools-list/2019-June/msg00099.html) was released in June of last year. It shipped with a major new feature: libvirt XML viewing and editing UI for new and existing domain, pools, volumes, networks.

Every VM, network, and storage object page has a **XML** tab at the top. Here's an example with that tab selected from the VM **Overview** section:

![VM XML editor]({static}/images/079-xml1.png){width="500"}

Here's an example of the XML view when just a disk is selected. Note it only shows that single device's libvirt XML:

![Disk XML editor]({static}/images/079-xml2.png){width="500"}

By default the XML is not editable; notice the warning at the top of the first image. After editing is enabled, the warning is gone, like in the second image. You can enable editing via Edit->Preferences from the main **Manager** window. Here's what the option looks like:

![XML edit preference]({static}/images/079-xml-prefs.png){width="500"}

A bit of background: We are constantly receiving requests to expose libvirt XML config options in virt-manager's UI. Some of these knobs are necessary for <1% but uninteresting to the rest. Some options are difficult to set from the command line because they must be set at VM install time, which means switch from virt-manager to virt-install which is not trivial. And so on. When these options aren't added to the UI, it makes life difficult for those affected users. It's also difficult and draining to have these types of justification conversations on the regular.

The XML editing UI was added to relieve some of the pressure on virt-manager developers fielding these requests, and to give more power to advanced virt users. The users that know they need an advanced option are usually comfortable editing the libvirt XML directly. The XML editor doesn't detract from the existing UI much IMO, and it is uneditable by default to prevent less knowledgeable users from getting into trouble. It ain't gonna win any awards for great UI, but the feedback has been largely positive so far.
