Title: Using git-remote-hg with bitbucket
Date: 2015-01-09 13:58
Author: Cole Robinson
Tags: fedora
Slug: using-git-remote-hg-with-bitbucket
Status: published

Occasionally I want to contribute to a project using mercurial on bitbucket.org (like pylint). Since I always forget the steps, I'm documenting here how I've managed that without having to actually [use]{.underline} mercurial.

-   From bitbucket.org, log in, find the repo you want to contribute to, use the web UI to fork it under your account.
-   `yum install git-remote-hg`
-   Clone your fork using git
    -   Generic format is: `git clone hg::$URL`
    -   So for my fork of **astroid**, the command looks like: `git clone hg::ssh://hg@bitbucket.org/crobinso/astroid`
-   Create a git branch, the name must start with 'branches/' to make mercurial happy when we eventually push things. So something like: `git checkout -b branches/myfix`</code>
-   Make your changes in the branch
-   Push the branch to your repo: `git push origin branches/myfix`
-   Use the bitbucket web UI to submit a pull request.
-   That's it.

Though I haven't figured out how to update a pull request... instead I've resorted to closing the first request, creating a new branch on my fork, and submitting a brand new pull request. There's probably some nicer automagic way but I haven't figured it out.

(Hopefully in the near future more of the python ecosystem will [move to git](http://lwn.net/Articles/623905/).)
