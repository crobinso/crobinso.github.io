Title: pylint in Fedora 20 supports gobject introspection
Date: 2014-04-08 10:00
Author: Cole Robinson
Tags: fedora, virt
Slug: pylint-in-fedora-20-supports-gobject
Status: published

[GObject introspection](https://wiki.gnome.org/GObjectIntrospection) is the magical plumbing that enables building multiple language bindings for a GObject-based library using not much more than API documentation. This is used by [PyGObject](https://wiki.gnome.org/PyGObject) to give us python access to gtk3, gdk, glib, etc. Pretty sweet.

Unfortunately the automagic nature of this confused [pylint](https://www.pylint.org/), claiming your 'from gi.repository import Gtk' import didn't exist, and losing many of its nice features when interacting with objects provided by introspection derived bindings.

I love pylint and it's a critical part of my python development workflow. So last year I decided to do my part and submit a patch to add some [gobject introspection knowledge to pylint](https://bitbucket.org/logilab/pylint-brain/issue/1/patch-pylint-brain-plugin-for-gobject).

It works by actually importing the module (like 'Gtk' above), inspecting all its classes and functions, and building stub code that pylint can analyze. It's not perfect, but it will catch things like misspelled method names. (Apparently newer python-astroid has some infrastructure to [inspect living objects](https://bitbucket.org/logilab/pylint-brain/issue/4/py2gi-rewrite-using-the-living-object), so likely the plugin will use that one day).

This support was released in python-astroid-1.0.1, which hit Fedora 20 at the beginning of March. Unfortunately a [a bug](https://bugzilla.redhat.com/show_bug.cgi?id=1079643) was causing a bunch of false positives with gobject-introspection, but that should be fixed with python-astroid-1.0.1-3 heading to F20.
