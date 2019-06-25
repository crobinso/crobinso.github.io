Title: cubietruck setup, though my card reader is flaky
Date: 2015-02-28 10:39
Author: Cole Robinson
Tags: fedora, virt
Slug: cubietruck-setup-though-my-card-reader
Status: published

Finally setup my cubietruck that I purchased late last year. Here it is under my desk running Fedora 21:


[![](http://2.bp.blogspot.com/-56h2OT138dY/VPHdMZi5DeI/AAAAAAAAAFs/8Adre1SpAQA/s1600/IMAG0315.jpg){width="320" height="181"}](http://2.bp.blogspot.com/-56h2OT138dY/VPHdMZi5DeI/AAAAAAAAAFs/8Adre1SpAQA/s1600/IMAG0315.jpg)


Riveting, I know.

I mostly just followed bits from [Rich's](https://rwmj.wordpress.com/2013/12/13/kvm-working-on-the-cubietruck/) and [Kashyap's](http://kashyapc.com/2014/12/09/cubietruck-qemu-kvm-and-fedora/) blog posts, and the [Fedora ARM install instructions](http://fedoraproject.org/wiki/Architectures/ARM/F21/Installation). I used this [serial adapter](https://www.amazon.com/gp/product/B009T2ZR6W/ref=oh_aui_search_detailpage?ie=UTF8&psc=1), though note you need to make sure to make sure the TX pin on the board is wired to the RX pin USB end, and vice versa. Probably obvious to some people but I would have been stumped if I hadn't seen it mentioned in an Amazon review.

Everything is working now but my hardware has a bit of a malfunction that I mentioned in [this fedora-arm thread](https://lists.fedoraproject.org/pipermail/arm/2015-February/009120.html). Basically the device can boot off the SD card, but linux doesn't detect it. If I wiggle the card around a lot while inserting it I can get linux to detect it about 1/5 of the time, but after rebooting the device is back to not being detected. In the thread, Hans guessed that the card-detect pin is flaky or not connecting well, but it doesn't affect the cubieboard firmware which just ignores that pin and assumes the device is present.

Since I was planning on using a SATA drive anyways, this isn't that big of a deal, just delete everything on the SD card except u-boot, and the SATA drive will be used /boot and /. But if I ever want to update u-boot on the SD card, I'll have to go through the whole wiggle process again and manually 'dd' it into place using the steps on the Fedora install page.
