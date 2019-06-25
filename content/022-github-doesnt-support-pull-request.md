Title: Github doesn't support pull-request notifications to mailing lists
Date: 2014-04-29 10:00
Author: Cole Robinson
Tags: fedora, virt
Slug: github-doesnt-support-pull-request
Status: published

Recently I played around with github a bit, with the intention of finding a useful setup for hosting [python-bugzilla](https://fedorahosted.org/python-bugzilla/) (and possibly virt-manager). However I want to preserve the traditional open source mailing list driven development model.

github's whole development model is built around pull requests. Personally I kinda like the setup, but for a pre-existing project built around patches on a mailing list it's quite a different workflow.

github doesn't allow disabling the pull-request option. This is understandable since it's pretty central to their entire model. However my main sticking point is that **github doesn't provide a straightforward way to send pull request notifications to a mailing list**. I don't want everyone on a mailing list to have to opt in to watching the repo on github to be notified of pull requests. I want non-github users to be able to contribute to pull request discussions on a mailing list. I want pull requests on the project mailing list since it's already a part of my workflow. I don't want my project to be one of those that [accumulates](https://github.com/torvalds/linux) [ignored](https://github.com/libguestfs/libguestfs) [pull-requests](https://github.com/qemu/qemu) because it isn't part of the project workflow and no one is watching the output.

Googling about this was quite frustrating, it was difficult to find a clear answer. I eventually found an [abandoned pull request to github-services](https://github.com/github/github-services/pull/284) that made everything clear. But not before I tried quite a few things. Here's what I tried:

-   Opening a github account using the mailing list address, 'watch' the repository. It works, but yeah, not too safe since anyone can just trigger a 'forgot password' reset email.
-   Put the repo in an 'organization', add the mailing list as a secondary address to your account, have all [notifications for the organization](https://gist.github.com/BPScott/1366790) go to the mailing list. But even secondary accounts work for the password reset, so that's out.
-   'email' webhook/service: At your github repo, go to settings-\>webhooks & services-\>configure services-\>email. Hey, this looks promising. The problem is it's quite limited in scope, only supporting email notifications for repo pushes and when  a public repo is added.
-   The actual webhook configuration is quite elaborate and allows notifying of pull-requests and everything else you would want to know, but that requires running an actual web service somewhere. But I have no interest in maintaining a public service just to proxy some email.

There's a [public repo for the bit of github](https://github.com/github/github-services) that the 'email' webhook lives under. I stuck [some thoughts on an open issue](https://github.com/github/github-services/issues/804#issuecomment-38390436) that more or less tracks the RFE to extend the email capabilities.

Someone out there with some spare time and ruby-fu want to take a crack at this? I think many old school open source projects would be thankful for it :)
