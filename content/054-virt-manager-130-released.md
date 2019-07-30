Title: virt-manager 1.3.0 released
Date: 2015-11-25 15:42
Author: Cole Robinson
Tags: fedora, virt
Slug: virt-manager-130-released
Status: published

Last night I released [virt-manager-1.3.0](https://www.redhat.com/archives/virt-tools-list/2015-November/msg00150.html). Not too much exciting in this release, just a lot of little improvements and bug fixes.

The highlights:

-   Git hosting moved to https://github.com/virt-manager/virt-manager
-   Switch translation infrastructure from transifex to fedora.zanata.org
-   Add dogtail UI tests and infrastructure
-   Improved support for s390x kvm (Kevin Zhao)
-   virt-install and virt-manager now remove created disk images if VM install startup fails
-   Replace urlgrabber usage with requests and urllib2
-   virt-install: add --network virtualport support for openvswitch (Daniel P. Berrange)
-   virt-install: support multiple --security labels
-   virt-install: support --features kvm\_hidden=on\|off (Pavel Hrdina)
-   virt-install: add --features pmu=on\|off
-   virt-install: add --features pvspinlock=on\|off (Abhijeet Kasurde)
-   virt-install: add --events on\_lockfailure=on\|off (Abhijeet Kasurde)
-   virt-install: add --network link\_state=up\|down
-   virt-install: add --vcpu placement=static\|auto
