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
			  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
			  -DCMAKE_C_FLAGS="$(CFLAGS) -pthread -Wno-unknown-warning-option -Wno-stringop-overflow -Wno-array-bounds -Wno-macro-redefined" \
			  -DCMAKE_CXX_FLAGS="$(CXXFLAGS) -pthread -Wno-macro-redefined" \
			  -DCMAKE_SYSTEM_NAME=$(SYSTEM_NAME) \
			  -DBORINGSSL_PREFIX=BSSL \
			  -DBORINGSSL_PREFIX_SYMBOLS=../symbols.txt \
			  -DCMAKE_ASM_FLAGS="-fPIC"

LIBDYLIB=$(PLATFORM)/build/ssl/libssl.a

all: .installed-$(PLATFORM)

$(PLATFORM): $(DEPS) | $(TARBALLS_LOCATION)/$(ARCHIVE).$(HASH_TYPE)
	rm -rf $(PLATFORM); mkdir -p $(PLATFORM)/build
	cd $(PLATFORM); $(ARCHIVE_TOOL) $(ARCHIVE_TOOL_FLAGS) $(TARBALLS_LOCATION)/$(ARCHIVE)
	cd $(PLATFORM); patch -p1 -i ../01-fix-at-hwcap2-definition.patch
	cd $(PLATFORM); patch -p1 -i ../02-symbols.patch
	cd $(PLATFORM)/build; $(CMAKE) $(CMAKE_OPTIONS) ..

$(LIBDYLIB): $(PLATFORM)
	$(MAKE) -C $(PLATFORM)/build crypto ssl

.installed-$(PLATFORM): $(LIBDYLIB)
	mkdir -p $(PREFIX)/include/boringssl/openssl
	mkdir -p $(PREFIX)/lib/boringssl
	cp -rf $(PLATFORM)/include/openssl/* $(PREFIX)/include/boringssl/openssl/
	# Copy the generated prefix header
	cp -rf $(PLATFORM)/build/symbol_prefix_include/* $(PREFIX)/include/boringssl/
	cp -f $(PLATFORM)/build/crypto/libcrypto.a $(PREFIX)/lib/boringssl/
	cp -f $(PLATFORM)/build/ssl/libssl.a $(PREFIX)/lib/boringssl/
	touch $@

clean:
	# Eğer dizin varsa içeri girip temizle, yoksa hata verme
	[ -d $(PLATFORM)/build ] && $(MAKE) -C $(PLATFORM)/build clean || true
	rm -f .installed-$(PLATFORM)

distclean::
	# Tüm platform dizinini ve install logunu sil
	rm -rf $(PLATFORM) .installed-$(PLATFORM)
