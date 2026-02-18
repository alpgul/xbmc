include ../../Makefile.include GO-VERSION ../../download-files.include
PREFIX=$(NATIVEPREFIX)
PLATFORM=$(NATIVEPLATFORM)
DEPS = ../../Makefile.include Makefile GO-VERSION ../../download-files.include

BASE_URL=https://dl.google.com/go

all: .installed-$(PLATFORM)

$(PLATFORM): $(DEPS) | $(TARBALLS_LOCATION)/$(ARCHIVE).$(HASH_TYPE)
	rm -rf $(PLATFORM)/*; mkdir -p $(PLATFORM)
	cd $(PLATFORM); $(ARCHIVE_TOOL) $(ARCHIVE_TOOL_FLAGS) $(TARBALLS_LOCATION)/$(ARCHIVE)

.installed-$(PLATFORM): $(PLATFORM)
	mkdir -p $(PREFIX)/bin $(PREFIX)/lib/go
	cp -rf $(PLATFORM)/* $(PREFIX)/lib/go/
	ln -sf ../lib/go/bin/go $(PREFIX)/bin/go
	ln -sf ../lib/go/bin/gofmt $(PREFIX)/bin/gofmt
	touch $@

clean:
	rm -f .installed-$(PLATFORM)
	rm -rf $(PLATFORM)

distclean::
	rm -rf $(PLATFORM) .installed-$(PLATFORM)
