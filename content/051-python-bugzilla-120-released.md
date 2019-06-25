Title: python-bugzilla 1.2.0 released
Date: 2015-04-08 17:16
Author: Cole Robinson
Tags: fedora, virt
Slug: python-bugzilla-120-released
Status: published

I've just released [python-bugzilla-1.2.0](https://lists.fedorahosted.org/pipermail/python-bugzilla/2015-April/000397.html). This release includes:

-   Add bugzilla new/query/modify --field flag (Arun Babu Neelicattu)
-   API support for ExternalBugs (Arun Babu Neelicattu, Brian Bouterse)
-   Add new/modify --alias support (Adam Williamson)
-   Bugzilla.logged\_in now returns live state (Arun Babu Neelicattu)
-   Fix getbugs API with latest Bugzilla releases

I'd like to expand a bit more on a couple of these changes.

<br/>
** bugzilla new/query/modify --field flag **

Arun had a good idea about adding a generic --field option to the CLI. Rather than depend on /usr/bin/bugzilla to grow a specific command line option for some new custom bugzilla field, you can use --field to get your work done.

For example, Red Hat bugzilla has a custom field called 'cf\_pm\_score' that's used for internal RHEL workflow. However /usr/bin/bugzilla doesn't have any explicit command line support for this field.

But if you wanted to alter the cf\_pm\_score field from the command line, you can now do:

`bugzilla modify $BUGID --field cf_pm_score=100`

Of course, for popular bugzilla fields we should make sure the command line tool has an explicit and document option, but this takes the pressure off of us to add an option for every custom Red Hat extension.

<br/>
** Bugzilla.logged\_in now returns live state **

A recurring problem people hit with the bugzilla API is receiving unexpected results because they aren't actually logged into bugzilla. This often happens when their cached bugzilla token has expired. For most operations the bugzilla API doesn't give any error in this case, and there's historically been no simple API to ask 'am I actually logged in?'

The Bugzilla API class has long had a property 'logged\_in' that wasn't very useful, only returning True for a very specific circumstance. Arun extended this with a heuristic to determine if we are \_actually\_ logged in to bugzilla.

So if you have any scripts that talk to the python-bugzilla API and depend on actually being logged in, add a check at the top of your code to bail out if logged\_in == False and save yourself some future confusion :)

IIRC the next major version of bugzilla does provide some API support in this area, so hopefully we can expand on this when newer bugzilla version are deployed.
