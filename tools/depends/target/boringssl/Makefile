include ../../Makefile.include BORINGSSL-VERSION ../../download-files.include
DEPS = ../../Makefile.include Makefile BORINGSSL-VERSION ../../download-files.include

SYSTEM_NAME := Linux
ifeq ($(PLATFORM),Darwin)
    SYSTEM_NAME := Darwin
endif

# configuration settings
CMAKE_OPTIONS=-DCMAKE_INSTALL_PREFIX=$(PREFIX) \
              -DBUILD_SHARED_LIBS=OFF \
			  -DCMAKE_BUILD_TYPE=Release \
			  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
			  -DCMAKE_SYSTEM_NAME=$(SYSTEM_NAME) \
			  -DBORINGSSL_PREFIX=BSSL \
			  -DGO_EXECUTABLE=$(GO) \
			  -DBORINGSSL_PREFIX_SYMBOLS=../symbols.txt

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
	mkdir -p $(PREFIX)/boringssl/include/openssl
	mkdir -p $(PREFIX)/boringssl/lib/pkgconfig
	cp -rf $(PLATFORM)/include/openssl/* $(PREFIX)/boringssl/include/openssl/
	# Copy the generated prefix header
	cp -rf $(PLATFORM)/build/symbol_prefix_include/* $(PREFIX)/boringssl/include/
	cp -f $(PLATFORM)/build/crypto/libcrypto.a $(PREFIX)/boringssl/lib/
	cp -f $(PLATFORM)/build/ssl/libssl.a $(PREFIX)/boringssl/lib/
	# Generate and install pkg-config files
	# libcrypto.pc
	( \
		echo "prefix=$(PREFIX)/boringssl"; \
		echo "exec_prefix=\$${prefix}"; \
		echo "libdir=\$${exec_prefix}/lib"; \
		echo "includedir=\$${prefix}/include"; \
		echo ""; \
		echo "Name: libcrypto"; \
		echo "Description: BoringSSL cryptography library"; \
		echo "Version: 1.1.1"; \
		echo "Libs: -L\$${libdir} -lcrypto"; \
		echo "Libs.private: -lz -ldl -pthread -latomic"; \
		echo "Cflags: -I\$${includedir}"; \
	) > $(PREFIX)/boringssl/lib/pkgconfig/libcrypto.pc
	# libssl.pc
	( \
		echo "prefix=$(PREFIX)/boringssl"; \
		echo "exec_prefix=\$${prefix}"; \
		echo "libdir=\$${exec_prefix}/lib"; \
		echo "includedir=\$${prefix}/include"; \
		echo ""; \
		echo "Name: libssl"; \
		echo "Description: BoringSSL Secure Sockets Layer"; \
		echo "Version: 1.1.1"; \
		echo "Requires: libcrypto"; \
		echo "Libs: -L\$${libdir} -lssl"; \
		echo "Cflags: -I\$${includedir}"; \
	) > $(PREFIX)/boringssl/lib/pkgconfig/libssl.pc
	# openssl.pc
	( \
		echo "prefix=$(PREFIX)/boringssl"; \
		echo "exec_prefix=\$${prefix}"; \
		echo "libdir=\$${exec_prefix}/lib"; \
		echo "includedir=\$${prefix}/include"; \
		echo ""; \
		echo "Name: OpenSSL"; \
		echo "Description: BoringSSL (OpenSSL compatible) - Secure Sockets Layer and cryptography libraries"; \
		echo "Version: 1.1.1"; \
		echo "Requires: libssl libcrypto"; \
		echo "Libs: -L\$${libdir} -lssl -lcrypto"; \
		echo "Cflags: -I\$${includedir}"; \
	) > $(PREFIX)/boringssl/lib/pkgconfig/openssl.pc
	touch $@

clean:
	rm -rf $(PLATFORM) .installed-$(PLATFORM)

distclean::
	rm -rf $(PLATFORM) .installed-$(PLATFORM)