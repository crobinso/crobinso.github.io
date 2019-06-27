Title: git up: The better git pull
Date: 2015-02-13 10:06
Author: Cole Robinson
Tags: fedora, virt
Slug: git-up-better-git-pull
Status: published

A while ago I stumbled across a nice git extension ['git up'](https://github.com/aanand/git-up). The [README synopsis](https://github.com/aanand/git-up#synopsis) lays out the motivation:

> `git pull` has two problems:
>
> -   It merges upstream changes by default, when it's really more polite to [rebase over them](https://www.gitready.com/advanced/2009/02/11/pull-with-rebase.html), unless your collaborators enjoy a commit graph that looks like bedhead.
> -   It only updates the branch you're currently on, which means `git push` will shout at you for being behind on branches you don't particularly care about right now.
>
> Solve them once and for all.

As implied above, git-up will update all your branches that are tracking a remote branch. This often comes in handy in fedora git repos:


```console
[crobinso@colepc openbios (master)]$ fedpkg pull
Already up-to-date.
[crobinso@colepc openbios (master)]$ git up
Fetching origin
f20  fast-forwarding...
master up to date
returning to master
```


Another useful bit is that it will stash and unstash uncommitted changes. Often times I find myself doing this:


```console
[crobinso@colepc ~]$ cd src/virt-manager/
# Hack some minor bug fix
[crobinso@colepc virt-manager (master *)]$
# Oops, I should pull first, maybe the issue is fixed
[crobinso@colepc virt-manager (master *)]$ git pull
Cannot pull with rebase: You have unstaged changes.
Please commit or stash them.
[crobinso@colepc virt-manager (master *)]$ git up
Fetching origin
stashing 1 changes
master up to date
unstashing
[crobinso@colepc virt-manager (master *)]$
```


Nowadays I don't even attempt the pull, `git up` is my reflex. (And yes I should just make it a reflex that I switch to a branch before doing any hacking...)

Nice to see that nowadays git-up is packaged in fedora, so grab it with `sudo yum install rubygem-git-up`
