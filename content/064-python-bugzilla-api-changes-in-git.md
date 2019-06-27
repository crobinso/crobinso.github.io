Title: python-bugzilla API changes in git
Date: 2016-06-07 20:06
Author: Cole Robinson
Tags: fedora
Slug: python-bugzilla-api-changes-in-git
Status: published

I've made a number of API changes to python-bugzilla in git. Most of it is removing old mis-designed features which I don't think anyone is actually using. I went through all apps I know of that use python-bugzilla (fedora bits like bodhi pkgdb infra scripts, bugwarrior, searchcode.com) to confirm as much and I don't think anything below will affect them. Even if there's no complaints I won't cut the release for 4-6 weeks.

The list is long but most changes are fairly straight forward. If any of this sounds controversial, or if I misjudged one of the 'unused' bits and should reconsider, please leave your thoughts here or on the python-bugzilla mailing list.

The interesting change is:

-   Bugzilla.bug\_autorefresh now defaults to False. Previously if trying to access Bug.foo, and 'foo' wasn't cached, the Bug() object would basically do a Bug.refresh() and fetch all the bug contents from the server. This default sucks, it can lead to poorly performing scripts and unnecessary bugzilla load. If you have code that uses include\_fields, exclude\_fields, or extra\_fields anywhere, this change may affect you. You can set Bugzilla().bug\_autorefresh = False before doing any bug lookup to force this off (with current versions) and catch any errors. If you hit issues you probably need to extend your include\_fields specifications. The reason for this change is that the old pattern made it too easy for people's scripts to unintentionally start requiring a much higher number of XMLRPC calls, thus completely negating the usage of include\_fields in the first place. Some more details over here: <https://github.com/python-bugzilla/python-bugzilla/blob/master/examples/bug_autorefresh.py> <https://bugzilla.redhat.com/show_bug.cgi?id=1297637>


These are slightly interesting and may impact a few people:

-   Credentials are now cached in ~/.cache/python-bugzilla/. If the old ~/.bugzilla{cookies,token} files are in place we will continue to update and use them. \* RHBugzilla.rhbz\_back\_compat \_\_init\_\_ attribute is gone. If the user manually set this to true, we would alter some Bug fields returned via query() to convert python lists into a single comma separated string, to match rhbugzilla output from before the 2012 upgrade. Convert your code to use the modern bugzilla list output.
-   bin/bugzilla was converted to argparse, which has a bug on python 2.7 that affects some possible command lines: https://bugs.python.org/issue9334 If you use a command like 'bugzilla modify --cc -foo@example.com' to remove that email from the CC list, you now need to ensure there's an equals sign in there, like --cc=-foo@example.com. That is backwards compatible with old python-bugzilla too, so update your scripts now. A few other options expect that format too.
-   bugzilla query --boolean\_chart option is removed. It provided a custom specification for crafting complex queries, similar to what the bugzilla UI can do. I don't think anyone is really using this, but if you are, generate a web query URL and pass it to bugzilla query --from-url '$URL' which is much easier to deal with.
-   bugzilla query 'boolean' options, where you could say 'bugzilla query --keywords 'foo & bar' to match both substrings, are no longer supported. If you need logic like this, use the --from-url technique mentioned above.
-   Bug.get\_history() is now Bug.get\_history\_raw() Bugzilla.bugs\_history is now Bugzilla.bugs\_history\_raw() This API is only a year old and unwisely returns raw output from bugzilla, which has some formatting oddities. I renamed it to \*\_raw so we have the future opportunity to add an API with better output.
-   The getbugsimple and getbugssimple APIs were removed. They were basically just wrappers around standard getbug() at this point. Use getbug/getbugs instead.
-   The simplequery API was removed. This basically matches the basic query from the bugzilla front page. Just use the standard query methods instead, see examples/query.py from git. I didn't find any users of this function.
-   Various whiteboard editing functions from the Bug object were removed. - getwhiteboard: this is just a wrapper around standard Bug attributes - appendwhiteboard, prependwhiteboard, setwhiteboard: these were just wrappers around standard build\_update/update\_bugs - addtag/gettags/deltag which minor wrappers around the \*whiteboard functions, and were poorly named, given that there's an actual bug 'tags' field at this point. See [examples/update.py](https://github.com/python-bugzilla/python-bugzilla/blob/master/examples/update.py) from git for examples of using the standard update APIs. That said I've never heard of anyone actually using these, and they were designed around really old RHBZ APIs.


These I doubt will actually affect anyone:

-   Bugzilla.initcookie() dropped... use Bugzilla.cookiefile = X instead 
-   Bugzilla.adduser() dropped... it was the same as Bugzilla.createuser 
-   RHBugzilla.multicall \_\_init\_\_ attribute is gone. It's been a no-op and raises a warning for a long time. 
-   Bugzilla.version string is gone... this was meant to describe the python-bugzilla API version but was never used. 
-   Initing like Bugzilla() with no options was previously allowed, but now requires an explicit Bugzilla(url=None). 
-   We no longer handle cookies in LWP format. We've been silently converting them to mozilla format for 2 years so I assume this doesn't affect anyone, but if it does, you might need to delete your caches in ~/.bugzilla{cookies,token} 
-   Bug.setstatus(), Bug.close() args 'private\_in\_it' and 'nomail' were removed: they have been no-ops for years 
-   Bug.addcomment() args 'timestamp', 'bz\_gid' and 'worktime' were removed: they've been no-ops for years
-   Bug.setassignee() arg 'reporter' was removed: it's thrown an error for years
