include ../../Makefile.include NGTCP2-VERSION ../../download-files.include
DEPS = ../../Makefile.include Makefile NGTCP2-VERSION ../../download-files.include

# Yeni izole yollarla güncellenmiş CMAKE_OPTIONS
CMAKE_OPTIONS := -DCMAKE_INSTALL_PREFIX=$(PREFIX) \
                 -DCMAKE_BUILD_TYPE=Release \
                 -DENABLE_STATIC_LIB=ON \
                 -DENABLE_SHARED_LIB=OFF \
                 -DENABLE_LIB_ONLY=ON \
                 -DENABLE_OPENSSL=OFF \
                 -DENABLE_BORINGSSL=ON \
                 -DOPENSSL_NO_OPTS=ON \
                 -DBORINGSSL_INCLUDE_DIR=$(PREFIX)/include/boringssl \
                 -DBORINGSSL_LIBRARIES="$(PREFIX)/lib/boringssl/libssl.a;$(PREFIX)/lib/boringssl/libcrypto.a"
LIBDYLIB=$(PLATFORM)/build/lib/$(BYPRODUCT)

all: .installed-$(PLATFORM)

$(PLATFORM): $(DEPS) | $(TARBALLS_LOCATION)/$(ARCHIVE).$(HASH_TYPE)
	rm -rf $(PLATFORM)/*; mkdir -p $(PLATFORM)/build
	cd $(PLATFORM); $(ARCHIVE_TOOL) $(ARCHIVE_TOOL_FLAGS) $(TARBALLS_LOCATION)/$(ARCHIVE)
	cd $(PLATFORM); patch -p1 < ../01-boringssl-prefix-fix.patch
	cd $(PLATFORM)/build; PKG_CONFIG_PATH=$(PREFIX)/lib/pkgconfig $(CMAKE) $(CMAKE_OPTIONS) ..


$(LIBDYLIB): $(PLATFORM)
	$(MAKE) -C $(PLATFORM)/build

.installed-$(PLATFORM): $(LIBDYLIB)
	$(MAKE) -C $(PLATFORM)/build install
	touch $@

clean:
	$(MAKE) -C $(PLATFORM)/build clean
	rm -f .installed-$(PLATFORM)

distclean::
	rm -rf $(PLATFORM) .installed-$(PLATFORM)
