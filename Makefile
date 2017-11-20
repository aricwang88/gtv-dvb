#############################################################################
#
# Makefile for Gtv-dvb
# License: GPL (General Public License)
#
# Get Gtv-dvb: https://github.com/vl-nix/gtv-dvb
#
#
# Depends
# -------
# gcc
# gtk+3
# gstreamer
# gst-plugins-base
# gst-plugins-good
# gst-plugins-ugly
# gst-plugins-bad gst-libav
#
#
# Make Target:
# ------------
#   $ make            all
#   $ make help       get the usage
#   $ make info       show variables
#   $ make depends    check dependencies
#   $ make compile    only build
#   $ make install    install
#   $ make uninstall  uninstall
#   $ make clean      clean all
#
#   $ For translators:
#	   make genpot     only xgettext -> pot
#	   make mergeinit  only msgmerge or msginit pot -> po
#	   make msgfmt     only msgfmt po -> mo
#
#===========================================================================


## Set prefix=PREFIX ( install files in PREFIX )
##==========================================================================
# prefix    = /usr
prefix      = $(HOME)/.local

program     = gtv-dvb
version     = 1.0

bindir      = $(prefix)/bin
datadir     = $(prefix)/share
desktopdir  = $(datadir)/applications
localedir   = $(datadir)/locale

obj_locale = $(subst :, ,$(LANGUAGE))

obj_depends = gtk+-3.0 gstreamer-1.0 gstreamer-plugins-base-1.0 gstreamer-plugins-good-1.0 gstreamer-plugins-bad-1.0 gstreamer-video-1.0


all: depends build translation


depends:
	for depend in $(obj_depends); do \
		echo $$depend; \
		pkg-config --exists --print-errors $$depend; \
	done

compile: build

build:
	gcc -Wall -Wextra \
		src/*.c \
		-o $(program) \
		`pkg-config gtk+-3.0 --cflags --libs` \
		`pkg-config gstreamer-video-1.0 --cflags --libs` \
		`pkg-config gstreamer-mpegts-1.0 --libs`

translation: genpot mergeinit msgfmt	

genpot:
	mkdir -p po
	xgettext src/*.c --language=C --keyword=N_ --escape --sort-output --from-code=UTF-8 --package-name=$(program) --package-version=$(version) -o po/$(program).pot
	sed 's|PACKAGE VERSION|$(program) $(version)|g;s|charset=CHARSET|charset=UTF-8|g' -i po/$(program).pot

mergeinit:
	for lang in $(obj_locale); do \
		echo $$lang; \
		if [ ! -f po/$$lang.po ]; then msginit -i po/$(program).pot --locale=$$lang -o po/$$lang.po; \
		else msgmerge --update po/$$lang.po po/$(program).pot; fi \
	done

msgfmt:
	for lang in $(obj_locale); do \
		echo $$lang; \
		msgfmt -v po/$$lang.po -o $$lang.mo; \
		mkdir -pv locale/$$lang/LC_MESSAGES/; \
		mv $$lang.mo locale/$$lang/LC_MESSAGES/$(program).mo; \
	done

install:
	mkdir -p $(DESTDIR)$(bindir) $(DESTDIR)$(datadir) $(DESTDIR)$(desktopdir)
	install -Dp -m0755 $(program) $(DESTDIR)$(bindir)/$(program)
	install -Dp -m0644 res/$(program).desktop $(DESTDIR)$(desktopdir)/$(program).desktop
	sed 's|bindir|$(bindir)|g' -i $(DESTDIR)$(desktopdir)/$(program).desktop
	cp -r locale $(DESTDIR)$(datadir)

uninstall:
	rm -fr $(DESTDIR)$(bindir)/$(program) $(DESTDIR)$(desktopdir)/$(program).desktop $(DESTDIR)$(localedir)/*/*/$(program).mo

clean:
	rm -f $(program) src/*.o po/$(program).pot
	rm -r locale


# Show variables.
info:
	@echo
	@echo 'program      :' $(program)
	@echo 'prefix       :' $(prefix)
	@echo 'bindir       :' $(bindir)
	@echo 'datadir      :' $(datadir)
	@echo 'desktopdir   :' $(desktopdir)
	@echo 'localedir    :' $(localedir)
	@echo 'obj_locale   :' $(obj_locale)
	@echo 'obj_depends  :' $(obj_depends)
	@echo


# Show help.
help:
	@echo 'Makefile for Gtv-dvb'
	@echo 'Get Gtv-dvb: https://github.com/vl-nix/gtv-dvb'
	@echo
	@echo 'Usage: make [TARGET]'
	@echo 'TARGETS:'
	@echo '  all        or make'
	@echo '  help       print this message'
	@echo '  info       show variables'
	@echo '  depends    check dependencies'
	@echo '  compile    only build'
	@echo '  install    install'
	@echo '  uninstall  uninstall'
	@echo '  clean      clean all'
	@echo
	@echo 'For translators:'
	@echo '  genpot     only xgettext -> pot'
	@echo '  mergeinit  only msgmerge or msginit pot -> po'
	@echo '  msgfmt     only msgfmt po -> mo'
	@echo

## End of the Makefile
#############################################################################