Title: python-bugzilla + bugzilla 5.0 API keys
Date: 2019-01-09 17:58
Author: Cole Robinson
Tags: fedora
Slug: python-bugzilla-bugzilla-50-api-keys
Status: published

For many uses of `/usr/bin/bugzilla` and python-bugzilla, it's necessary to actually be logged in to a bugzilla server. Creating bugs, editing bugs, querying private data, etc.

Up until now anyone that's used the command line tool has periodically had to do a `bugzilla login` to refresh their authentication cache. In older bugzilla versions this was an HTTP cookie, more recently it's a bugzilla API token. Generally `login` calls were needed infrequently on a single machine as tokens would remain valid for a long time.

Recently, bugzilla.redhat.com received a big update to bugzilla 5.0. However with that update it seems like API tokens now expire after a week, which has necessitated lots more `bugzilla login` calls than I'm used to.

Thankfully with **bugzilla 5.0** and later there's a better option: API keys. Here's how to to use them transparently with `/usr/bin/bugzilla` and all python-bugzilla library usage. Here's steps for enabling API keys with bugzilla.redhat.com, but the same process should roughly apply to other bugzilla instances too.

- Login to the bugzilla web UI
- Click on your email
- Select **Preferences**
- Select **API Keys**
- Generate an API key with an optional comment like `python-bugzilla`

Afterwards the screen will look something like this:

![Bugzilla web UI API key setup]({static}/images/073-python-bugzilla-bugzilla-50-api-keys-1.png){width="640" height="384"}


`MY-EXAMPLE-API-KEY` is not my actual key, I just replaced it for demo purposes. The actual key is a long string of characters and numbers. Copy that string value and write a bugzillarc file like this:
```ini
$ cat ~/.config/python-bugzilla/bugzillarc
[bugzilla.redhat.com]
api_key=MY-EXAMPLE-API-KEY
```

That's it, `/usr/bin/bugzilla` and python-bugzilla using tools should pick it up automagically. Note, API keys are as good as passwords in certain ways, so treat it with the same secrecy you would treat a password.
