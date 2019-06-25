Title: bodhi-push-updates: Script for easily pushing updates to stable
Date: 2015-03-31 14:29
Author: Cole Robinson
Tags: fedora
Slug: bodhi-push-updates-script-for-easily
Status: published

I wrote a helper script that saves some clicks if you need to push a bunch of pending Fedora package updates to stable. I figure it's useful for other folks too so I published it here:

<https://github.com/crobinso/bodhi-push-updates>

Description from the README:

> Basically works like this:
>
> -   Query all your pending updates
> -   Filter out the ones that haven't reached the testing timeout, by looking for the 'can be pushed to stable' comment from bodhi.
> -   For each appropriate update:
>     -   Show the update karma
>     -   Filter out bodhi process comments ('pushed to testing' etc.)
>     -   Filter out PASSED taskotron messages
>     -   Show the remaining comments
>     -   Prompt the user if they'd like to push this update to stable
> -   Push all the requested updates to stable
>
> So if you push a lot of updates this can save a bit of time clicking around in the web UI or invoking bodhi manually from the command line.
