Title: python-bugzilla 1.0.0 released
Date: 2014-03-26 08:10
Author: Cole Robinson
Tags: fedora
Slug: python-bugzilla-100-released
Status: published

I released [python-bugzilla 1.0.0](https://lists.fedorahosted.org/pipermail/python-bugzilla/2014-March/000246.html) yesterday. Since [Arun](https://github.com/abn) led the charge to get python 3 support merged, it seemed like as good a time as any to go 1.0 :)

python-bugzilla provides the /usr/bin/bugzilla command line tool that is heavily used in Fedora and internally at Red Hat. The library itself is used by parts of Fedora infrastructure like pkgdb and bodhi.

This major changes in this release:

- Python 3 support (Arun Babu Neelicattu)
- Port to python-requests (Arun Babu Neelicattu)
- bugzilla: new: Add --keywords, --assigned\_to, --qa\_contact (Lon
  Hohberger)
- bugzilla: query: Add --quicksearch, --savedsearch
- bugzilla: query: Support saved searches with --from-url
- bugzilla: --sub-component support for all relevant commands

The sub component stuff is a recent bugzilla.redhat.com extension that hasn't been used much yet. I believe the next bugzilla.redhat.com update will add sub components for the Fedora kernel package, so bugs can be assigned to things like 'Kernel-\>USB', 'Kernel-\>KVM", etc. Quite helpful for complicated packages.

But I don't know if it's going to be opened up as an option for any Fedora package, I guess we'll just have to wait and see. I assume there will be an announcement about it at some point.
