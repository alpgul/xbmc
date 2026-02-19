# FindBoringSSL
# -----------
# PkgConfig kullanarak BoringSSL (OpenSSL taklidi) kütüphanelerini bulur.

if(NOT TARGET ${APP_NAME_LC}::${CMAKE_FIND_PACKAGE_NAME})

  # 1. PkgConfig modülünü yükle
  find_package(PkgConfig QUIET)

  # 2. PKG_CONFIG_PATH değişkenine senin kodi-deps içindeki klasörü ekleyelim
  # Böylece sistemdeki openssl.pc yerine senin hazırladığını görür.
  set(old_pkg_path $ENV{PKG_CONFIG_PATH})
  set(ENV{PKG_CONFIG_PATH} "${DEPENDS_PATH}/boringssl/lib/pkgconfig")

  # 3. Senin hazırladığın openssl.pc dosyasını sorgula
  pkg_check_modules(PC_BORINGSSL QUIET openssl)

  # PKG_CONFIG_PATH'i eski haline getirelim (sistemi kirletmemek için)
  set(ENV{PKG_CONFIG_PATH} ${old_pkg_path})

  if(PC_BORINGSSL_FOUND)
    # 4. Bulunan değerlerle "Imported" hedefleri oluşturalım
    if(NOT TARGET BoringSSL::SSL)
      add_library(BoringSSL::SSL UNKNOWN IMPORTED)
      set_target_properties(BoringSSL::SSL PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${PC_BORINGSSL_INCLUDE_DIRS}"
        IMPORTED_LOCATION "${DEPENDS_PATH}/boringssl/lib/libssl.a"
        INTERFACE_LINK_LIBRARIES "BoringSSL::Crypto"
      )
    endif()

    if(NOT TARGET BoringSSL::Crypto)
      # Genellikle pkg-config birden fazla kütüphane döner, ikinciyi crypto sayabiliriz
      # Veya doğrudan yolu elle verebilirsin:
      add_library(BoringSSL::Crypto UNKNOWN IMPORTED)
      set_target_properties(BoringSSL::Crypto PROPERTIES
        IMPORTED_LOCATION "${DEPENDS_PATH}/boringssl/lib/libcrypto.a"
      )
    endif()

    set(BORINGSSL_SSL_LIBRARY "${DEPENDS_PATH}/boringssl/lib/libssl.a")
    set(BORINGSSL_CRYPTO_LIBRARY "${DEPENDS_PATH}/boringssl/lib/libcrypto.a")

    # 5. Senin meşhur "Alias" işlemini yapalım
    add_library(${APP_NAME_LC}::${CMAKE_FIND_PACKAGE_NAME} ALIAS BoringSSL::SSL)

    message(STATUS "BoringSSL (via PkgConfig) found: ${PC_BORINGSSL_PREFIX}")
  else()
    if(BoringSSL_FIND_REQUIRED)
      message(FATAL_ERROR "BoringSSL pkg-config file (openssl.pc) not found!")
    endif()
  endif()

endif()