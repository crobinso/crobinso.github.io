Title: Better output with /usr/bin/bugzilla --json
Date: 2020-10-03
Author: Cole Robinson
Tags: fedora
Slug: bugzilla-json-output
Status: published

In python-bugzilla 2.4.0 I added a `--json` output switch to `/usr/bin/bugzilla`.

IMO this is the optimal way to process large amounts of bugzilla query output
from the command laine. so if you are already doing just that with the old output
options, consider switching to `--json`. That is, if you aren't ready to make the full
leap to using the library directly ;)


#### Replace usage of `--raw`

The older `--raw` output mode will print bug contents in a strange custom array-like output
format that is poorly specified and impossible to parse reliably. Please use `--json` instead.
`--raw` may be removed in the future.


#### Replace usage of `--outputformat`

The older `--outputformat` option processes bug contents and prints them out in the
specified string format. Variables are referenced with something akin to RPM macro
format. Example:

```
$ bugzilla query --outputformat '%{id}::%{summary}' --id 1234567
1234567::Package should not ship a separate emacs sub-package
```

This has served us pretty well, but besides being a custom and poorly specified
format, it has limitations with formatting subvalues of non-string bugzilla fields.

With `--json` you can make use of the powerful `jq` tool which
gives you the ability to do all manner of querying and processing of
the output.

This example duplicates the `--outputformat` example above:
```console
$ bugzilla query --json --id 1234567 | jq -r '.bugs[0] | "\(.id)::\(.summary)"'
1234567::Package should not ship a separate emacs sub-package
```

This example demonstrates accessing a structured subfield like `comments`. We print the first comment's creation time for a list of bugs:
```console
$ bugzilla query --json \
    --product Fedora --component virt-manager --status OPEN | \
    jq -r ".bugs[].comments[0].creation_time"
2020-07-08T16:35:14Z
2020-08-30T14:22:42Z
2020-04-12T20:28:24Z
2020-02-05T09:57:48Z
2020-09-09T15:17:32Z
2019-12-28T22:29:05Z
2020-08-15T21:20:02Z
2020-09-21T13:59:37Z
2020-09-18T08:50:28Z
```


#### Optimizing `--json` queried data

One downside of `--json` compared to `--outputformat` is that it will return
all bug data even if you only plan to parse a subset of it. For big queries,
or ones performed repeatedly, this can cause unnecessary load on the bugzilla
instance.

`--outputformat` knows what fields you need, so will only fetch those from
the bugzilla instance, transferring the minimally required amount of data.
You can achieve the same thing manually with `--json` by also specifying
the option `--includefield field1 --includefield field2 ..` for every
field you need to process. Example:

```console
$ bugzilla query --json --includefield summary --id 1234567
{
  "bugs": [
    {
      "id": 1234567,
      "summary": "Package should not ship a separate emacs sub-package"
    }
  ]
}
```

As a more general tip, use the bugzilla web UI to generate a query that
only checks for changes after a certain timestamp that is relevant to
you, and pass that to
[`query --from-url $URL`](https://blog.wikichoon.com/2014/05/invoking-bugzilla-query-url-from.html),
so you can limit the time window for the data you are fetching.


#### Using `--json` to find bugzilla API field names

This applies to `--raw` as well, but you can use `--json` to find out the
API name of custom fields in the bugzilla instance. Many times I've been asked
questions like: 'How do I access bugzilla.redhat.com field FOOBAR from python-bugzilla?'.
The simplest way to figure it out is to find a bug that you know has data filled in for
that field, pass that bug ID to `bugzilla query --json --id XXX` and examine the output
to find the field name. If they are custom fields they usually have a prefix like `cf_`,
at least for bugzilla.redhat.com.
