Title: Fedora 18 notification sound is now a 'drip' noise
Date: 2013-01-28 13:30
Author: Cole Robinson
Tags: fedora
Slug: fedora-18-notification-sound-is-now
Status: published

One random change I noticed during the F18 cycle was that the default notification noise changed from an innocuous 'bell' sound to a 'water drip' noise. While I turn off all terminal noises, this sound still pops up in Firefox and Thunderbird when a ctrl-f quick search doesn't find a match, and in my F18 VMs with default configuration. And while I'm sure many developers just turn off all sound effects, I find them useful for email and IRC notifications.

This new sound is offensive to my ears, one small step below nails on a chalk board. Unfortunately there is no way to undo this change in gnome-control-center's Sound panel, just 2 choices for the drip noise ('default' and 'drip'), and some other comical choices like a dog 'bark'. Nothing as unoffensive as the previous default. I (just yesterday) [filed a bug](https://bugzilla.redhat.com/show_bug.cgi?id=904299) against control-center asking for a way to restore the old behavior.

However, if you want to revert it in a hacky way, this should cover you until the next time sound-theme-freedesktop is updated:


```
sudo wget http://cgit.freedesktop.org/sound-theme-freedesktop/plain/stereo/bell.oga?id=38bc773912317a2163083b6f483fbc8e6fb61123 -O /usr/share/sounds/freedesktop/stereo/bell.oga
```


`<rant\>`Why this was changed is really anyone's guess. The [commit message](http://cgit.freedesktop.org/sound-theme-freedesktop/commit/?id=18e55993d311444854a73ed6b6e6670fcbac4946) is needlessly vague. I couldn't find any mailing list posting on freedesktop lists or gnome's desktop-devel-list, nor any bug report that might have spurned the change. The 'bell' noise was just overwritten in place, despite the fact that the new noise is not remotely a 'bell' sound, though I guess the bell name is about the action and not the sound content. The git repo had been unchanged for nearly 3 years, not an issue in itself, just makes the above bits stick out even more. And finally I really don't understand why the most common sound effect on a stock install would be a noise that is an annoyance by nature: a dripping/leaking faucet.`</rant/>`
