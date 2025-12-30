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
	cd $(PLATFORM)/build; $(CMAKE) $(CMAKE_OPTIONS) ..

$(LIBDYLIB): $(PLATFORM)
	$(MAKE) -C $(PLATFORM)/build

.installed-$(PLATFORM): $(LIBDYLIB)
	$(MAKE) -C $(PLATFORM)/build install
	mkdir -p $(PREFIX)/include/openssl
	cp -rf $(PLATFORM)/include/openssl/* $(PREFIX)/include/openssl/
	touch $@

clean:
	$(MAKE) -C $(PLATFORM)/build clean
	rm -f .installed-$(PLATFORM)

distclean::
	rm -rf $(PLATFORM) .installed-$(PLATFORM)
