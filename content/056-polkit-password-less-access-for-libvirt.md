Title: Polkit password-less access for the 'libvirt' group
Date: 2016-01-04 08:00
Author: Cole Robinson
Tags: fedora, virt
Slug: polkit-password-less-access-for-libvirt
Status: published

Many users, who admin their own machines, want to be able to use tools like virt-manager without having to enter a root password. Just google 'virt-manager without password' and see all the hits. I've [seen](https://goldmann.pl/blog/2012/12/03/configuring-polkit-in-fedora-18-to-access-virt-manager/) [many](https://niranjanmr.wordpress.com/2013/03/20/auth-libvirt-using-polkit-in-fedora-18/) [blogs](https://www2.linuxsysadmintutorials.com/configure-polkit-to-run-virsh-as-a-normal-user/) [and](https://www.rockpenguin.com/2014/03/allowing-non-root-users-access-to-libvirt-and-virsh-using-polkit/) [articles](https://major.io/2015/04/11/run-virsh-and-access-libvirt-as-a-regular-user/) over the years describing various ways to work around it.

The password prompting is via libvirt's polkit integration. The idea is that we want the applications to run as a regular unprivileged user (running GUI apps as root is considered a no-no), and only use the root authentication for talking to system libvirt instance. Most workarounds suggest installing a polkit rule to allow your user, or a particular user group, to access libvirt without needing to enter the root password.

In [libvirt v1.2.16](https://www.redhat.com/archives/libvir-list/2015-June/msg00000.html) we finally [added](https://github.com/libvirt/libvirt/commit/e94979e901517af9fdde358d7b7c92cc055dd50c) official support for this (and backported to Fedora22+). The group is predictably called 'libvirt'. This matches polkit rules that debian and suse were already shipping too.

So just add your user to the 'libvirt' group and enjoy passwordless virt-manager usage:


`usermod --append --groups libvirt $(whoami)`
