Title: virt-manager is deprecated in RHEL (but only RHEL)
Date: 2020-06-16 13:00
Author: Cole Robinson
Tags: fedora, virt
Slug: virt-manager-deprecated-in-rhel
Status: published

**TL;DR**: I'm the primary author of virt-manager. virt-manager is deprecated in RHEL8 in favor of cockpit, but ONLY in RHEL8 and future RHEL releases. The upstream project virt-manager is still maintained and is still relevant for other distros.

Google 'virt-manager deprecated' and you'll find some discussions suggesting
virt-manager is no longer maintained, [Cockpit](https://cockpit-project.org/) is replacing virt-manager, virt-manager is going to be removed from every distro, etc. These conclusions are misinformed.

The primary source for this confusion is the section 'virt-manager has been deprecated' from the [RHEL8 release notes virtualization deprecation section](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/8.2_release_notes/deprecated_functionality#deprecated-functionality_virtualization). Relevant quote from the RHEL8.2 docs:

> The Virtual Machine Manager application, also known as virt-manager, has been deprecated.
> The RHEL 8 web console, also known as Cockpit, is intended to become its replacement in a subsequent release.

What that means:

* virt-manager is in RHEL8 and will be there for the lifetime of RHEL8.
* Red Hat engineering effort assigned to the virt-manager UI has been reduced compared to previous RHEL versions.
* The tentative plan is to not ship the virt-manager UI in RHEL9.

Why is this happening? As I understand it, RHEL wants to roughly standardize on Cockpit as their host admin UI tool. It's a great project with great engineers and great UI designers. Red Hat is going all in on it for RHEL and aims to replace the mismash of system-config-X tools and project specific admin frontends (like virt-manager) with a unified project. (Please note: this is my paraphrased understanding, I'm not speaking on behalf of Red Hat here.)

Notice though, this is all about RHEL. virt-manager is not deprecated upstream, or deprecated in other distros automatically just because RHEL has made this decision. The upstream virt-manager project continues on and Red Hat continues to allocate resources to maintain it.

Also, I'm distinguishing virt-manager UI from the virt-manager project, which includes tools like `virt-install`. I fully expect `virt-install` to be shipped in RHEL9 and actively maintained (FWIW Cockpit uses it behind the scenes).

And even if the virt-manager UI is not in RHEL9 repos, it will likely end up shipped in EPEL, so the UI will still be available for install, just through external repos.

Overall my personal opinion is that as long as libvirt+KVM is in use on linux desktops and servers, virt-manager will be relevant. I don't expect anything to change in that area any time soon.
