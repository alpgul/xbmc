include ../../Makefile.include BORINGSSL-VERSION ../../download-files.include
DEPS = ../../Makefile.include Makefile BORINGSSL-VERSION ../../download-files.include

SYSTEM_NAME := Linux # Varsayılan değer.
ifeq ($(PLATFORM),Darwin)
    SYSTEM_NAME := Darwin
endif

# configuration settings
CMAKE_OPTIONS=-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
              -DBUILD_SHARED_LIBS=OFF \
			  -DCMAKE_BUILD_TYPE=Release \
			  -DCMAKE_POSITION_INDEPENDENT_CODE=on \
			  -DCMAKE_C_FLAGS="$(CFLAGS) -Wno-unknown-warning-option -Wno-stringop-overflow -Wno-array-bounds -Wno-macro-redefined" \
			  -DCMAKE_CXX_FLAGS="$(CXX_FLAGS) -Wno-macro-redefined" \
			  -DCMAKE_SYSTEM_NAME=$(SYSTEM_NAME)

LIBDYLIB=$(PLATFORM)/build/ssl/libssl.a

all: .installed-$(PLATFORM)

$(PLATFORM): $(DEPS) | $(TARBALLS_LOCATION)/$(ARCHIVE).$(HASH_TYPE)
	rm -rf $(PLATFORM); mkdir -p $(PLATFORM)/build
	cd $(PLATFORM); $(ARCHIVE_TOOL) $(ARCHIVE_TOOL_FLAGS) $(TARBALLS_LOCATION)/$(ARCHIVE)
	cd $(PLATFORM); patch -p1 -i ../01-fix-at-hwcap2-definition.patch
	cd $(PLATFORM)/build; $(CMAKE) $(CMAKE_OPTIONS) ..

$(LIBDYLIB): $(PLATFORM)
	$(MAKE) -C $(PLATFORM)/build crypto ssl

.installed-$(PLATFORM): $(LIBDYLIB)
	# make install yerine manuel kurulum yapıyoruz
	mkdir -p $(PREFIX)/include/openssl
	mkdir -p $(PREFIX)/lib
	cp -rf $(PLATFORM)/include/openssl/* $(PREFIX)/include/openssl/
	cp -f $(PLATFORM)/build/crypto/libcrypto.a $(PREFIX)/lib/
	cp -f $(PLATFORM)/build/ssl/libssl.a $(PREFIX)/lib/
	# Eğer decrepit kütüphanesi oluştuysa onu da kopyalayalım (isteğe bağlı)
	test -f $(PLATFORM)/build/decrepit/libdecrepit.a && cp -f $(PLATFORM)/build/decrepit/libdecrepit.a $(PREFIX)/lib/ || true
	touch $@

clean:
	$(MAKE) -C $(PLATFORM)/build clean
	rm -f .installed-$(PLATFORM)

distclean::
	rm -rf $(PLATFORM) .installed-$(PLATFORM)
