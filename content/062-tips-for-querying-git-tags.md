Title: Tips for querying git tags
Date: 2016-01-20 10:00
Author: Cole Robinson
Tags: fedora, virt
Slug: tips-for-querying-git-tags
Status: published


With package maintenance, bug triage, and email support, I often need to look at a project's git tags to know about the latest releases, when they were released, and what releases contain certain features. Here's a couple workflow tips that make my life easier.


### Better git tag listing

Based on Peter Hutterer's ['git bi'](http://who-t.blogspot.com/2012/06/git-branch-info.html) alias for improved branch listing (which is great and highly recommended), I made one for improved tags output that I mapped as 'git tags'. Output looks like:


[![](http://1.bp.blogspot.com/-S1JscfM_bNg/U8WjuPH4hYI/AAAAAAAAAEc/6oZXuvPiHh8/s1600/Screenshot+from+2014-07-15+17:56:45.png){width="400" height="109"}](http://1.bp.blogspot.com/-S1JscfM_bNg/U8WjuPH4hYI/AAAAAAAAAEc/6oZXuvPiHh8/s1600/Screenshot+from+2014-07-15+17:56:45.png)

-   Shows tag name, commit message, commit ID, and date, all colorized. Commit message is redundant for many projects that tag the release commit, but it's interesting in some cases.
-   Tags are listed by date rather than alphabetically. Some projects change tag string formats, or versioning schemes, that then don't sort correctly when listed alphabetically. Sorting by date makes it easy to see the latest tag. Often I just want to know what the latest tag or the latest stable release is, this makes it easy.

The alias code is:

```ini
[alias]
   tags = "!sh -c ' \
git for-each-ref --format=\"%(refname:short)\" refs/tags | \
while read tag; do \
   git --no-pager log -1 --format=format:\"$tag %at\" $tag; echo; \
done | \
sort -k 2 | cut -f 1 --delimiter=\" \" | \
while read tag; do \
   fmt=\"%Cred$tag:%Cblue %s %Cgreen%h%Creset (%ai)\"; \
   git --no-pager log -1 --format=format:\"$fmt\" $tag; echo; \
done'"
```



### Find the first tag that contains a commit

This seems to come up quite a bit for me. An example is [here](http://www.redhat.com/archives/libvir-list/2014-July/msg00832.html); a user was asking about a virt-install feature, and I wanted to tell them what version it appeared in. I grepped `git log`, found the commit, then ran:


```console
$ git describe --contains 87a611b5470d9b86bf57a71ce111fa1d41d8e2cd
v1.0.0~201
```


That shows me that v1.0.0 was the first release with the feature they wanted, just take whatever is to the left of the tilde.

This often comes in handy with backporting as well: a developer will point me at a bug fix commit ID, I run git describe to see what upstream version it was released in, so I know what fedora package versions are lacking the fix.

Another tip here is to use the --match option to only search tags matching a particular glob. I've used this to filter out matching against a maintenance or bugfix release branch, when I only wanted to search major version releases.


### Don't pull tags from certain remotes

For certain repos like qemu.git, I add a lot of git remotes pointing to individual developer's trees for occasional patch testing. However if trees have lots of non-upstream tags, like for use with pull-requests, they can interfere with my workflow for backporting patches. Use the --no-tags option for this: `git remote add --no-tags $repo`
