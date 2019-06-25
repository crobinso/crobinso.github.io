Title: Setting custom network names on Fedora
Date: 2018-10-04 21:27
Author: Cole Robinson
Tags: fedora, virt
Slug: setting-custom-network-names-on-fedora
Status: published

[systemd predictable network names](https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/) give us host interface names like **enp3s0**. On one of my hosts, I have two interfaces: one that is my regular hard wired connection, and another I only plug in occasionally for some virt network testing. I can never remember the systemd names, so I want to rename the interfaces to something more descriptive for my needs. in my case **lan0main** and **lan1pcie**

The page referenced says to use systemd links. However after struggling with that for a while I'm that's only relevant to systemd-networkd usage and doesn't apply to Fedora's default use of NetworkManager. So I needed another way.

Long story short I ended up with some custom udev rules that are patterned after the old 70-persistent-net.rules file:


```console
$ cat /etc/udev/rules.d/99-cole-nic-names.rules
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="70:8b:cd:80:e5:5f", ATTR{type}=="1", NAME="lan0main"
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="68:05:ca:1a:f5:da", ATTR{type}=="1", NAME="lan1pcie"
```
