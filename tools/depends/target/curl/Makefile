include ../../Makefile.include CURL-VERSION ../../download-files.include
DEPS = ../../Makefile.include Makefile CURL-VERSION ../../download-files.include \
                  01-apple-pkgconfig_disable_requires.patch \
                  02-boringssl-prefix-fix.patch \
                  03-name-fix.patch

# configuration settings
CONFIGURE=cp -f $(CONFIG_SUB) $(CONFIG_GUESS) .; \
           CPPFLAGS="$(CPPFLAGS) -DBORINGSSL_PREFIX=BSSL -include $(PREFIX)/boringssl/include/boringssl_prefix_symbols.h" \
          ./configure --prefix=$(PREFIX) \
                      --disable-shared \
                      --disable-ldap \
                      --without-libssh2 \
                      --disable-ntlm-wb \
                      --enable-ipv6 \
                      --without-librtmp \
                      --without-libidn2 \
                      --with-ca-fallback \
                      --with-openssl=$(PREFIX)/boringssl \
                      --with-nghttp2=$(PREFIX) \
                      --with-zlib \
                      --without-libpsl \
                      --without-zstd \
                      --without-brotli \
                      --without-gssapi \
                      --without-gsasl \
                      --without-hyper \
                      --with-ngtcp2=$(PREFIX) \
                      --with-nghttp3=$(PREFIX) \
                      --without-quiche \
                      --without-msh3 \
                      --without-gnutls \
                      --without-nss \
                      --without-mbedtls \
                      --without-wolfssl

LIBDYLIB=$(PLATFORM)/lib/.libs/$(BYPRODUCT)

all: .installed-$(PLATFORM)

$(PLATFORM): $(DEPS) | $(TARBALLS_LOCATION)/$(ARCHIVE).$(HASH_TYPE)
	rm -rf $(PLATFORM)/*; mkdir -p $(PLATFORM)
	cd $(PLATFORM); $(ARCHIVE_TOOL) $(ARCHIVE_TOOL_FLAGS) $(TARBALLS_LOCATION)/$(ARCHIVE)
	cd $(PLATFORM); patch -p1 -i ../01-apple-pkgconfig_disable_requires.patch
	cd $(PLATFORM); patch -p1 -i ../02-boringssl-prefix-fix.patch
	cd $(PLATFORM); patch -p1 -i ../03-name-fix.patch
	cd $(PLATFORM); $(AUTORECONF) -vif
	cd $(PLATFORM); $(CONFIGURE)

$(LIBDYLIB): $(PLATFORM)
	$(MAKE) -C $(PLATFORM)/lib

.installed-$(PLATFORM): $(LIBDYLIB)
	# install only libcurl and includes
	-$(MAKE) -C $(PLATFORM)/lib install
	-$(MAKE) -C $(PLATFORM)/include install
	# make sure to also install libcurl.pc, we need to do
	# this because we are selectively installing only libcurl
	-$(MAKE) -C $(PLATFORM) install-pkgconfigDATA
	touch $@

clean:
	$(MAKE) -C $(PLATFORM) clean
	rm -f .installed-$(PLATFORM)

distclean::
	rm -rf $(PLATFORM) .installed-$(PLATFORM)

.PHONY: update-cacert
update-cacert: $(PLATFORM)
	$(PLATFORM)/lib/mk-ca-bundle.pl -u $(CMAKE_SOURCE_DIR)/system/certs/cacert.pem
