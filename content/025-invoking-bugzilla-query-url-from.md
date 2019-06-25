Title: Invoking a bugzilla query URL from the command line
Date: 2014-05-20 10:00
Author: Cole Robinson
Tags: fedora
Slug: invoking-bugzilla-query-url-from
Status: published

The /usr/bin/bugzilla tool provided by [python-bugzilla](https://fedorahosted.org/python-bugzilla/) is quite handy for managing batch actions on bugs or quickly performing simple queries. However when you want to perform a crazy query with all sorts of boolean rules that the web UI exposes, the command line gets pretty unwieldy.

However, there's a simple workaround for this. Generate a query URL using the bugzilla web UI, and pass it to /usr/bin/bugzilla like:

`bugzilla query --from-url "$url"`


That's it! Then you can tweak the output as you want using --outputformat or similar. This also works for savedsearch URLs as well.

So, say I go to the bugzilla web UI and say 'show me all open, upstream libvirt bugs that haven't received a comment in since 2013'. It generates a massive URL. Here's what the URL looks like:

> https://bugzilla.redhat.com/buglist.cgi?bug_status=NEW&bug_status=ASSIGNED&bug_status=POST&bug_status=MODIFIED&bug_status=ON_DEV&bug_status=ON_QA&bug_status=VERIFIED&bug_status=RELEASE_PENDING&classification=Community&component=libvirt&f1=longdesc&list_id=2372821&n1=1&o1=changedafter&product=Virtualization%20Tools&query_format=advanced&v1=2013-12-31

Just pass that that thing as $url in the above command, and you should see the same results as the web search (if your results aren't the same, you might need to do 'bugzilla login' first to cache credentials).

This is also easy to do via the python API:

```python
#!/usr/bin/python

import bugzilla
bzapi = bugzilla.Bugzilla("bugzilla.redhat.com")
buglist = bzapi.query(bzapi.url_to_query("URL"))

for bug in buglist:
    print bug.summary
```

The caveat: as of now this only works with bugzilla.redhat.com, which has an API extension that allows it to interpret the URL syntax as regular query parameters. My understanding is that this may be available upstream at some point, so other bugzilla instances will benefit as well.
