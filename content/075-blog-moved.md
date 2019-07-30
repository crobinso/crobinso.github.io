Title: Blog moved to Pelican and GitHub Pages
Date: 2019-07-30 15:30
Author: Cole Robinson
Tags: fedora, virt
Slug: blog-moved
Status: published

I've moved my blog from blogger.com to a static site generated with
[Pelican](https://blog.getpelican.com/) and hosted on GitHub Pages. This
is a dump of some of the details.

The content is hosted in three branches across two repos:

* **[blog/gh-pages](https://github.com/crobinso/blog/tree/gh-pages)**: <https://blog.wikichoon.com> HTML content
* **[crobinso.github.io/master](https://github.com/crobinso/crobinso.github.io/tree/master)**: <https://wikichoon.com> front page HTML content
* **[crobinso.github.io/pelican](https://github.com/crobinso/crobinso.github.io/tree/pelican)**: website source content and theme

The motivation for the split is that according to this [pelican SEO](https://blog.kmonsoor.com/pelican-how-to-make-seo-friendly/) article, **master** branches of GitHub repos are indexed by google, so if you store HTML content in a **master** branch your canonical blog might be battling your GitHub repo in the search results. And since you can only put content in the **master** branch of a `$username.github.io` repo, I added a separate blog.git repo. Maybe I could shove all the content into the **blog/gh-pages** branch I think dealing with multiple subdomains prevents it. I've already spent too much timing playing with all this stuff though so that's for another day to figure out. Of course, suggestions welcome, blog comments are enabled with Disqus.

One issue I hit is that pushing updated content to **blog/gh-pages** doesn't consistently trigger a new GitHub Pages deployment. There's a bunch of hits about this around the web (this [stackoverflow post](https://stackoverflow.com/questions/20422279/github-pages-are-not-updating) in particular) but no authoritative explanation about what criteria GitHub Pages uses to determine whether to redeploy. The simplest 'fix' I found is to tweak the `index.html` content via the GitHub web UI and commit the change which seems to consistently trigger a refresh as reported by the repo's [deployments page](https://github.com/crobinso/blog/deployments).

You may notice the blog looks a lot like stock [Jekyll](https://jekyllrb.com/) with its [minima](https://github.com/jekyll/minima) theme. I didn't find any Pelican theme that I liked as much as minima, so I grabbed the CSS from a minima instance and started adapting the Pelican [simple-bootstrap](https://github.com/getpelican/pelican-themes/tree/master/simple-bootstrap) theme to use it. The end result is basically a simple reimplementation of minima for Pelican. I learned a lot in the process but it likely would have been much simpler if I just used Jekyll in the first place, but I'm in too deep to switch now!
