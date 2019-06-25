Title: github 'hub' command line tool
Date: 2016-01-13 10:00
Author: Cole Robinson
Tags: fedora, virt
Slug: github-hub-command-line-tool
Status: published

I don't often need to contribute patches to code hosted on github; most of the projects I contribute to are either old school and don't use github for anything but mirroring their main git repo, or are small projects I entirely maintain so I don't submit pull-requests.

But when I do need to submit patches, [github's hub tool](https://hub.github.com/) makes my life a lot simpler, which allows forking repositories and submitting pull-requests very easily from the command line.

The 'hub' tool wants to be installed as an alias for 'git'. I originally tried that, but it made my bash prompt insanely slow since I show the [current git branch and dirty state in my bash prompt](https://fedoraproject.org/wiki/Git_quick_reference#Display_current_branch_in_bash). When I first encountered this, I filed a [bug](https://github.com/github/hub/issues/254) against the hub tool (with a bogus workaround), and nowadays it seems they have a [disclaimer in their README](https://github.com/github/hub#is-your-shell-prompt-slow).

Their recommended fix is to `s/git/command git/g` in git-prompt.sh, which doesn't work too well if you use the linked fedora suggestion of pointing at the package installed file in /usr/share, so I avoid the alias. You can run 'hub' standalone, but instead I like to do:


```
 sudo dnf install hub
 ln -s /usr/bin/hub /usr/libexec/git-core/git-hub
```


Then I can `git hub fork` and `git hub pull-request` all I want :)
