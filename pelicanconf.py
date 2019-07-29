# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

import datetime

AUTHOR = 'Cole Robinson'
SITENAME = 'Cole Robinson'
SITESUBTITLE = "Cole's dev log"
SITEURL = 'http://localhost:8000'
FRONTPAGE = 'http://localhost:8000/pages/frontpage.html'
TIMEZONE = 'America/New_York'
DEFAULT_LANG = 'en'
DATE = str(datetime.datetime.now())

PATH = 'content'
THEME = "theme"
STATIC_PATHS = ["images"]

# We don't use any of these feeds
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

FEED_MAX_ITEMS = 10
FEED_ALL_ATOM = 'feeds/all.atom.xml'
TAG_FEED_ATOM = 'feeds/{slug}.atom.xml'

DEFAULT_PAGINATION = False

ARTICLE_URL = "{date:%Y}/{date:%m}/{slug}.html"
ARTICLE_SAVE_AS = "{date:%Y}/{date:%m}/{slug}.html"

GOOGLE_ANALYTICS = "example-test"

PLUGINS = [
    "extended_sitemap",
]
