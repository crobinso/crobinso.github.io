Title: virt-convert tool removed in virt-manager.git
Date: 2020-07-11
Author: Cole Robinson
Tags: fedora,virt
Slug: virt-convert-removed
Status: published

The next release of virt-manager will not ship the `virt-convert` tool, I removed it upstream with [this commit](https://github.com/virt-manager/virt-manager/commit/ee9f93074bf74bd2e4c5177d750e7c438c7790cf).

Here's the slightly edited quote from my original proposal to remove it:

> virt-convert takes an ovf/ova or vmx file and spits out libvirt XML.
> It started as a code drop a long time ago that could translate back and
> forth between vmx, ovf, and virt-image, a [long dead appliance format](https://blog.wikichoon.com/2014/04/deprecating-little-used-tool-virt-image1.html).
> In 2014 I [changed virt-convert](https://blog.wikichoon.com/2014/04/virt-convert-command-line-has-been.html) to do vmx -> libvirt and ovf ->
> libvirt which was a CLI breaking change, but I never heard a peep of a
> complaint. It doesn't do a particularly thorough job at its
> intended goal, I've seen 2-3 bug reports in the past 5 years and
> generally it doesn't seem to have any users. Let's kill it. If anyone
> has the desire to keep it alive it could live as a separate project
> that's a wrapper around virt-install but there's no compelling reason to
> keep it in virt-manager.git IMO

That mostly sums it up. If there's any users of virt-convert out there, you likely
can get similar results by extracting the relevant disk image from the
`.vmx` or `.ovf` config, pass it to `virt-manager` or `virt-install`, and let
those tools fill in the defaults. In truth that's about all `virt-convert` did in
to begin with.
