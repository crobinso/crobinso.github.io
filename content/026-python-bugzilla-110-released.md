Title: python-bugzilla 1.1.0 released
Date: 2014-06-01 15:50
Author: Cole Robinson
Tags: fedora
Slug: python-bugzilla-110-released
Status: published

I just released python-bugzilla 1.1.0, you can see the release announcement [over here](https://lists.fedorahosted.org/pipermail/python-bugzilla/2014-June/000268.html). Updates in progress for f19, f20, rawhide, and epel6.

This release includes:

- Support for bugzilla tokens (Arun Babu Nelicattu)
- bugzilla: Add query/modify --tags
- bugzilla --login: Allow to login and run a command in one shot
- bugzilla --no-cache-credentials: Don't use or save cached credentials
  when using the CLI
- Show bugzilla errors when login fails
- Don't pull down attachments in bug.refresh(), need to get
  bug.attachments manually
- Add Bugzilla bug\_autorefresh parameter.

Some of these changes deserve a bit more explanation. This is just adapted from the release announcement, but I wanted to give these changes a bit more attention here on the blog.


#### Bugzilla tokens

Sometime later in the year, bugzilla.redhat.com will be updated to a new version of bugzilla that replaces API cookie authentication with a non-cookie token system. I don't fully understand the reasoning so don't ask :) Regardless, this release supports the new token infrastructure along side the existing cookie handling.

Users shouldn't notice any difference: we cache the token in `~/.bugzillatoken` so things work the same as the current cookie auth.

If you use `cookiefile=None` in the API to tell bugzilla <u>not</u> to cache any login credentials, you will now also want to specify `tokenfile=None` (hint hint fedora infrastructure).


#### `bugzilla --login` and `bugzilla --no-cache-credentials`

Right now the only way to perform an authenticated bugzilla command on a new machine requires running a one time `bugzilla login` to cache credentials before running the desired command.

Now you can just do `bugzilla --login $MY_COMMAND` and the login process will be initiated before invoking the command.

Additionally, the `--no-cache-credentials` option will tell the bugzilla tool to <u>not</u> save any credentials to `~/.bugzillacookies` or `~/.bugzillatoken`.


#### `Bugzilla.bug_autorefresh`

When interacting with a `Bug` object, if you attempt to access a property (say, `bugobj.component`) that hasn't already been fetched from the bugzilla instance, python-bugzilla will do an automatic `getbug` refresh call to pull down every property for said bug in an attempt to satisfy the request.

This is convenient for a one off API invocation, but for recurring scripts this is a waste of time and bugzilla bandwidth. The autorefresh can be avoided by passing a properly formatted `include_fields` to your query request, where `include_fields` contains every `Bug` property you will access in your script.

However it's still quite easy to extend a script with a new property usage and forget to adjust `include_fields`. Things will continue to work due to the autorefresh feature but your script will be far slower and wasteful.

A new `Bugzilla` class property has been added, `bug_autorefresh`. Set this to False to disable the autorefresh feature for newly fetched bugs. This will cause an explicit error to be raised if your code is depending on autorefresh.

Please consider setting this property for your recurring scripts. Example:

```python
bzapi = Bugzilla("bugzilla.redhat.com")
bzapi.bug_autorefresh = False
```

`autorefresh` can be disabled for individual bugs with:

```python
bug.autorefresh = False
```
