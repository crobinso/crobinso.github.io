Title: virt-manager 1.4.0 release
Date: 2016-06-18 11:06
Author: Cole Robinson
Tags: fedora, virt
Slug: virt-manager-140-release
Status: published

I've just released virt-manager 1.4.0. Besides the [spice GL bits that I previously talked about](https://blog.wikichoon.com/2016/05/spice-openglvirgl-acceleration-on.html), nothing too much exciting in this release except a lot of virt-install/virt-xml command line extensions.

The changelog highlights:

-   virt-manager: spice GL console support (Marc-André Lureau, Cole Robinson)
-   Bump gtk and pygobject deps to 3.14
-   virt-manager: add checkbox to forget keyring password (Pavel Hrdina)
-   cli: add --graphics gl= (Marc-André Lureau)
-   cli: add --video accel3d= (Marc-André Lureau)
-   cli: add --graphics listen=none (Marc-André Lureau)
-   cli: add --transient flag (Richard W.M. Jones)
-   cli: --features gic= support, and set a default for it (Pavel Hrdina)
-   cli: Expose --video heads, ram, vram, vgamem
-   cli: add --graphics listen=socket
-   cli: add device address.type/address.bus/...
-   cli: add --disk seclabelX.model (and .label, .relabel)
-   cli: add --cpu cellX.id (and .cpus, and .memory)
-   cli: add --network rom\_bar= and rom\_file=
-   cli: add --disk backing\_format=
