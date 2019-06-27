Title: python-bugzilla 2.0.0 released!
Date: 2017-02-08 16:22
Author: Cole Robinson
Tags: fedora
Slug: python-bugzilla-200-released
Status: published

I'm happy to announce a new release of python-bugzilla, version 2.0.0.

This release contains several small to medium API breaks as [previously mentioned](https://blog.wikichoon.com/2016/06/python-bugzilla-api-changes-in-git.html) on the blog. If you hit any issues, check that page first to see if it's an expected change.
 
The major changes in the release are:

-   Several fixes for use with bugzilla 5
-   This release contains several smallish API breaks:
-   Bugzilla.bug\_autorefresh now defaults to False
-   Credentials are now cached in ~/.cache/python-bugzilla/
-   bin/bugzilla was converted to argparse
-   bugzilla query --boolean\_chart option is removed
-   Unify command line flags across sub commands
-   More details at: <https://blog.wikichoon.com/2016/06/python-bugzilla-api-changes-in-git.html>
