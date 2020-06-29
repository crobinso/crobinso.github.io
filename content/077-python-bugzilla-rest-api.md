Title: python-bugzilla REST API support
Date: 2020-06-29 13:00
Author: Cole Robinson
Tags: fedora
Slug: python-bugzilla-rest-api
Status: published

I just released **[python-bugzilla](https://github.com/python-bugzilla/python-bugzilla) 2.4.0**. The main interesting bit it adds is support for [Bugzilla's REST API](https://wiki.mozilla.org/Bugzilla:REST_API).

All previous versions of python-bugzilla and `/usr/bin/bugzilla` only used the XMLRPC API, but that is deprecated in Bugzilla 5.0+ and all new API development is taking place on the REST API.

In practice there isn't any released bugzilla version that has big differences between the two API versions. On bugzilla.redhat.com specifically the XMLRPC API is still recommended, because some custom features are not available over REST yet. Note though that bugzilla.mozilla.org is looking at [disabling the XMLRPC API entirely](https://bugzilla.mozilla.org/show_bug.cgi?id=1599274), but they are usually ahead of the Bugzilla curve.

By default, python-bugzilla will use some URL parsing heuristics to try to guess if the
passed URL is for XMLRPC or REST.

* If URL contains `/xmlrpc`, assume XMLRPC
* If URL contains `/rest`, assume REST
* If the URL does not contain a path:
    * Try appending `/xmlrpc.cgi` and if the URL exists, use it
    * Try appending `/rest` and if the URL exists, use it
* Otherwise just attempt to initialize the XMLRPC backend

In practice this should mean previously used URLs will continue to use XMLRPC.

The `Bugzilla` API class also `force_rest` and `force_xmlrpc` init arguments to
force use of a specific API for the passed URL. Whether REST or XMLRPC is used
the existing API should continue to work as expected, it's simply a backend detail.

From `/usr/bin/bugzilla` there aren't any explicit command line options to force
use of one API or the other. If you pass a URL with an explicit `/rest` or
`/xmlrpc.cgi` then the API will pick the correct backend based on the heuristic
above. If your URL has a weirdly named REST API endpoint you can probably trick
the heuristic with a funky URL like `https://fakebz.example.com/weird-rest-endpoint?/rest`
