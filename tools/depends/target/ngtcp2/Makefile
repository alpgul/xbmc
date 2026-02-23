include ../../Makefile.include NGTCP2-VERSION ../../download-files.include
DEPS = ../../Makefile.include Makefile NGTCP2-VERSION ../../download-files.include

_LIBS=-lssl -lcrypto
ifeq ($(OS),android)
	_LIBS+=-lstdc++
endif
ifeq ($(OS),linux)
	ifeq ($(TARGET_PLATFORM),webos)
		_LIBS+=-lstdc++
	endif
endif
# Yeni izole yollarla güncellenmiş CMAKE_OPTIONS
CMAKE_OPTIONS := -DCMAKE_INSTALL_PREFIX=$(PREFIX) \
                 -DCMAKE_BUILD_TYPE=Release \
                 -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
                 -DENABLE_STATIC_LIB=ON \
                 -DENABLE_SHARED_LIB=OFF \
                 -DENABLE_LIB_ONLY=ON \
                 -DBUILD_TESTING=OFF \
                 -DENABLE_OPENSSL=OFF \
                 -DENABLE_BORINGSSL=ON \
                 -DBORINGSSL_INCLUDE_DIR=$(PREFIX)/boringssl/include \
                 -DBORINGSSL_LIBRARIES="-L$(PREFIX)/boringssl/lib $(_LIBS)"

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