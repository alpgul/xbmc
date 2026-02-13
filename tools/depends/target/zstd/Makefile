include ../../Makefile.include ZSTD-VERSION ../../download-files.include
DEPS = ../../Makefile.include Makefile ZSTD-VERSION ../../download-files.include

# Cross-compile değişkenlerini zstd'ye geçirmek için hazırlıyoruz
ZSTD_MAKE_ARGS = CC="$(CC)" \
                 CXX="$(CXX)" \
                 AR="$(AR)" \
                 RANLIB="$(RANLIB)" \
				 CFLAGS="$(CFLAGS) -fPIC -pthread" \
                 CXXFLAGS="$(CXXFLAGS) -fPIC -pthread" \
                 LDFLAGS="$(LDFLAGS) -pthread" \
                 PREFIX=$(PREFIX)

LIBDYLIB=$(PLATFORM)/lib/$(BYPRODUCT)

all: .installed-$(PLATFORM)

$(PLATFORM): $(DEPS) | $(TARBALLS_LOCATION)/$(ARCHIVE).$(HASH_TYPE)
	rm -rf $(PLATFORM)/*; mkdir -p $(PLATFORM)
	cd $(PLATFORM); $(ARCHIVE_TOOL) $(ARCHIVE_TOOL_FLAGS) $(TARBALLS_LOCATION)/$(ARCHIVE)

$(LIBDYLIB): $(PLATFORM)
	# Burada ZSTD_MAKE_ARGS ekledik
	$(MAKE) -C $(PLATFORM)/lib libzstd.a $(ZSTD_MAKE_ARGS)

.installed-$(PLATFORM): $(LIBDYLIB)
	# Burada da ZSTD_MAKE_ARGS ekledik
	$(MAKE) -C $(PLATFORM)/lib install-pc install-static install-includes $(ZSTD_MAKE_ARGS)
	touch $@

clean:
	$(MAKE) -C $(PLATFORM)/lib clean
	rm -f .installed-$(PLATFORM)

distclean::
	rm -rf $(PLATFORM) .installed-$(PLATFORM)