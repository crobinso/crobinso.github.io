Title: virt-manager 3.0.0 released!
Date: 2020-09-16
Author: Cole Robinson
Tags: fedora,virt
Slug: virt-manager-300-released
Status: published

Yesterday I released [virt-manager 3.0.0](https://www.redhat.com/archives/virt-tools-list/2020-September/msg00003.html). Despite the major version number bump, things shouldn't look too different from the previous release. For me the major version number bump reflects certain feature removals (like dropping virt-convert), and the large amount of internal code changes that were done, though there's a few long awaited features sprinkled in like virt-install `--cloud-init` support which I plan to write more about later.

This release includes:

* virt-install --cloud-init support ([Athina Plaskasoviti](https://athinapl.home.blog/2019/08/25/gsoc-2019-cloud-init-configuration-for-virt-manager-virt-install/), Cole Robinson)
* [The virt-convert tool has been removed](https://blog.wikichoon.com/2020/07/virt-convert-removed.html). Please use virt-v2v instead
* A handful of UI XML configuration options have been removed, in an effort to reduce maintenance ongoing maintenance burden, and to be more consistent with what types of UI knobs we expose. The [XML editor](https://blog.wikichoon.com/2020/07/virt-manager-xml-editor.html) is an alternative in most cases. For a larger discussion see [this thread](https://www.redhat.com/archives/virt-tools-list/2019-June/msg00117.html) and virt-manager's [DESIGN.md](https://github.com/virt-manager/virt-manager/blob/master/DESIGN.md) file.
* The 'New VM' UI now has a 'Manual Install' option which creates a VM without any required install media
* In the 'New VM' UI, the network/pxe install option has been removed. If you need network boot, choose 'Manual Install' and set the boot device after initial VM creation
* 'Clone VM' UI has been reworked and simplified
* 'Migrate VM' UI now has an XML editor for the destination VM
* Global and per-vm option to disable graphical console autoconnect. This makes it easier to use virt-manager alongside another client like virt-viewer
* virt-manager: set guest time after VM restore (Michael Weiser)
* virt-manager: option to delete storage when removing disk device (Lily Nie)
* virt-manager: show warnings if snapshot operation is unsafe (Michael Weiser)
* Unattended install improvements (Fabiano Fidêncio)
* cli: new --xml XPATH=VAL option for making direct XML changes
* virt-install: new --reinstall=DOMAIN option
* virt-install: new --autoconsole text|graphical|none option
* virt-install: new --os-variant detect=on,require=on suboptions
* cli: --clock, --keywrap, --blkiotune, --cputune additions (Athina Plaskasoviti)
* cli: add --features kvm.hint-dedicated.state= (Menno Lageman)
* cli: add --iommu option (Menno Lageman)
* cli: Add --graphics websocket= support (Petr Benes)
* cli: Add --disk type=nvme source.* suboptions
* cli: Fill in all --filesystem suboptions
* Translation string improvements (Pino Toscano)
* Convert from .pod to .rst for man pages
* Switch to pytest as our test runner
* Massively improved unittest and uitest code coverage
* Now using github issues as our bug tracker
