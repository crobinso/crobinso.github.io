PY?=python3
PELICAN?=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py
FRONTPAGEOUTPUTDIR=$(CURDIR)/frontpageoutput

DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
	PELICANOPTS += --relative-urls
endif

help:
	@echo 'Makefile for a pelican Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make devserver [PORT=8000]          serve and regenerate together      '
	@echo '   make clean                          remove the generated files         '
	@echo '   make publish                        generate using production settings '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make serve-global [SERVER=0.0.0.0]  serve (as root) to $(SERVER):80    '
	@echo '   make github                         upload the web site via gh-pages   '
	@echo '                                                                          '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html   '
	@echo 'Set the RELATIVE variable to 1 to enable relative urls                    '
	@echo '                                                                          '

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)
	[ ! -d $(FRONTPAGEOUTPUTDIR) ] || rm -rf $(FRONTPAGEOUTPUTDIR)

atomlinks:
	make clean
	mkdir -p $(OUTPUTDIR)/feeds/posts/default/-
	# Backcompat symlink for blogger advertised feed
	ln -fs $(OUTPUTDIR)/feeds/all.atom.xml $(OUTPUTDIR)/feeds/posts/default/index.html
	ln -fs $(OUTPUTDIR)/feeds/fedora.atom.xml $(OUTPUTDIR)/feeds/posts/default/-/fedora
	ln -fs $(OUTPUTDIR)/feeds/virt.atom.xml $(OUTPUTDIR)/feeds/posts/default/-/virt

serve:
ifdef PORT
	$(PELICAN) -rl $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT)
else
	$(PELICAN) -rl $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
endif

serve-global:
ifdef SERVER
	$(PELICAN) -rl $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT) -b $(SERVER)
else
	$(PELICAN) -rl $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT) -b 0.0.0.0
endif


devserver:
	make atomlinks
	make serve

publish:
	make atomlinks
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS)
	# Custom changes for blog frontpage
	mkdir -p $(FRONTPAGEOUTPUTDIR)
	mv $(OUTPUTDIR)/pages/frontpage.html $(FRONTPAGEOUTPUTDIR)/index.html
	# svg can not be accessed cross domain, so we need to put a theme copy
	# At wikichoon.com for the front page to access
	cp -r $(OUTPUTDIR)/theme $(FRONTPAGEOUTPUTDIR)/theme
	sed -i -e "s%blog.wikichoon.com/theme%wikichoon.com/theme%g" $(FRONTPAGEOUTPUTDIR)/index.html

github: publish
	# Update the front page in this repo
	ghp-import \
		--message="Generate Pelican site" \
		--branch=master \
		--cname=wikichoon.com \
		$(FRONTPAGEOUTPUTDIR)
	ghp-import \
		--message="Generate Pelican site" \
		--branch=blog-gh-pages \
		--cname=blog.wikichoon.com \
		$(OUTPUTDIR)
	git push origin master
	git push -f blog blog-gh-pages:gh-pages
	@echo -e "\n\nMake sure the content is deployed: https://github.com/crobinso/blog/deployments"

.PHONY: html help clean regenerate serve serve-global devserver stopserver publish github
