Title: check-pylint: mini tool for running pylint anywhere
Date: 2016-06-10 08:46
Author: Cole Robinson
Tags: fedora, virt
Slug: check-pylint-mini-tool-for-running
Status: published

pylint and pep8 are indispensable tools for python development IMO. For projects I maintain I've long ago added a 'setup pylint' sub-command to run both commands, and I've documented this as a necessary step in the contributor guidelines.

But over the years I've accumulated many repos for small bits of python code that never have need for a setup.py script, but I still want the convenience of being able to run pylint and pep8 with a single command and a reasonable set of options.

So, a while back I wrote this tiny '[check-pylint](https://github.com/crobinso/check-pylint)' script which does exactly that. The main bit it adds is automatically searching the current directory for python scripts and modules and passing them to pylint/pep8. From the README:


> Simple helper script that scoops up all python modules and scripts beneath the current directory, and passes them through pylint and pep8. Has a bit of smarts to ignore .git directory, and handle files that don't end in .py
>
> The point is that you can just fire off 'check-pylint' in any directory containing python code and get a quick report.
