Title: tip: Launch a new terminal with F1
Date: 2016-01-06 10:00
Author: Cole Robinson
Tags: fedora, virt
Slug: tip-launch-new-terminal-with-f1
Status: published

Back when I first switched to gnome-shell with Fedora 16, I read a lot of blog posts and wiki pages about keyboard shortcuts, extensions that people were using, praise and complaints, etc. Somewhere in all that (I can't remember where), I picked up a tip that I now use dozens of times a day and couldn't live without: remapping F1 to launch a new terminal.

It didn't even take much training to get used to it, because the method is just so much quicker than anything involving the mouse, or super key, or alt+f2, that I took to it immediately. And from there it was a small step to get used to using `exit` to actually quit a terminal, leading to drastically less mouse usage (yes my habits were quite crappy on gnome2).

It also has the added benefit of unmapping the help dialog from F1, which I've never once used intentionally, and every unintentional usage (of which there were many) would make my machine churn pretty hard for a good few seconds before popping up the dialog.

It's pretty easy to make the change on F23:


-   From gnome-shell desktop, go to **Activities->Keyboard**
-   Navigate to **Shortcuts->Custom Shortcuts**
-   Under launchers, disable **Launch help browser**
-   Under **Custom shortcuts**, click **+**, map `F1` to `gnome-terminal`


I'm sure if you use a single terminal + tmux, or guake, this isn't interesting, but maybe it will help someone like it helped me.
