include ../../Makefile.include NGTCP2-VERSION ../../download-files.include
DEPS = ../../Makefile.include Makefile NGTCP2-VERSION ../../download-files.include

# CMake configuration options
CMAKE_OPTIONS=-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
              -DCMAKE_BUILD_TYPE=Release \
              -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
              -DENABLE_STATIC_LIB=ON \
              -DENABLE_SHARED_LIB=OFF \
			  -DBUILD_TESTING=OFF \
              -DENABLE_LIB_ONLY=ON \
              -DENABLE_PYTHON_BINDINGS=OFF \
              -DENABLE_OPENSSL=OFF \
              -DENABLE_BORINGSSL=ON \
              -DWITH_LIBNGHTTP3=ON \
              -DBORINGSSL_INCLUDE_DIR=$(PREFIX)/include \
              -DBORINGSSL_LIBRARIES="-L$(PREFIX)/lib -lssl -lcrypto -lpthread" \
              -DHAVE_SSL_SET_QUIC_EARLY_DATA_CONTEXT=1

LIBDYLIB=$(PLATFORM)/build/lib/$(BYPRODUCT)

all: .installed-$(PLATFORM)

$(PLATFORM): $(DEPS) | $(TARBALLS_LOCATION)/$(ARCHIVE).$(HASH_TYPE)
	rm -rf $(PLATFORM)/*; mkdir -p $(PLATFORM)/build
	cd $(PLATFORM); $(ARCHIVE_TOOL) $(ARCHIVE_TOOL_FLAGS) $(TARBALLS_LOCATION)/$(ARCHIVE)
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
