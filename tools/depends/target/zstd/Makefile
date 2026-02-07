include ../../Makefile.include ZSTD-VERSION ../../download-files.include
DEPS = ../../Makefile.include Makefile ZSTD-VERSION ../../download-files.include

LIBDYLIB=$(PLATFORM)/lib/$(BYPRODUCT)

all: .installed-$(PLATFORM)

$(PLATFORM): $(DEPS) | $(TARBALLS_LOCATION)/$(ARCHIVE).$(HASH_TYPE)
	rm -rf $(PLATFORM)/*; mkdir -p $(PLATFORM)
	cd $(PLATFORM); $(ARCHIVE_TOOL) $(ARCHIVE_TOOL_FLAGS) $(TARBALLS_LOCATION)/$(ARCHIVE)

$(LIBDYLIB): $(PLATFORM)
	$(MAKE) -C $(PLATFORM)/lib libzstd.a PREFIX=$(PREFIX)

.installed-$(PLATFORM): $(LIBDYLIB)
	$(MAKE) -C $(PLATFORM)/lib install-pc install-static install-includes PREFIX=$(PREFIX)
	touch $@

clean:
	$(MAKE) -C $(PLATFORM)/lib clean
	rm -f .installed-$(PLATFORM)

distclean::
	rm -rf $(PLATFORM) .installed-$(PLATFORM)