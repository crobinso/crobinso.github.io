# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'Cole Robinson'
SITENAME = "Cole's dev log"
SITEURL = 'http://localhost:8000'
TIMEZONE = 'America/New_York'
DEFAULT_LANG = 'en'

PATH = 'content'
THEME = "theme"

# We don't use any of these feeds
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None
FEED_ALL_ATOM = 'feeds/all.atom.xml'
TAG_FEED_ATOM = 'feeds/{slug}.atom.xml'

DEFAULT_PAGINATION = False

ARTICLE_URL = "{date:%Y}/{date:%m}/{slug}.html"
ARTICLE_SAVE_AS = "{date:%Y}/{date:%m}/{slug}.html"
