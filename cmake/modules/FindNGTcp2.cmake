#.rst:
# FindNGTcp2
# ----------
# Finds the NGTcp2 library
#
# This will define the following targets:
#
#   NGTcp2::NGTcp2                    - The NGTcp2 core library
#   NGTcp2::NGTcp2CryptoBoringSSL     - The NGTcp2 crypto backend library (BoringSSL)

if(NOT TARGET NGTcp2::NGTcp2)
  find_package(PkgConfig)
  if(PKG_CONFIG_FOUND AND NOT (WIN32 OR WINDOWSSTORE))
    pkg_check_modules(NGTCP2 libngtcp2 QUIET)
    pkg_check_modules(NGTCP2_CRYPTO_BORINGSSL libngtcp2_crypto_boringssl QUIET)

    find_library(NGTCP2_LIBRARY NAMES ngtcp2_static ngtcp2
                                HINTS ${NGTCP2_LIBDIR})
    find_library(NGTCP2_CRYPTO_LIBRARY NAMES ngtcp2_crypto_boringssl_static ngtcp2_crypto_boringssl
                                       HINTS ${NGTCP2_CRYPTO_BORINGSSL_LIBDIR})

    set(NGTCP2_INCLUDE_DIR ${NGTCP2_INCLUDEDIR})
  else()

    find_path(NGTCP2_INCLUDE_DIR NAMES ngtcp2/ngtcp2.h
                                 HINTS ${DEPENDS_PATH}/include
                                 ${${CORE_PLATFORM_LC}_SEARCH_CONFIG})
    find_library(NGTCP2_LIBRARY NAMES ngtcp2 ngtcp2_static
                                HINTS ${DEPENDS_PATH}/lib
                                ${${CORE_PLATFORM_LC}_SEARCH_CONFIG})
    find_library(NGTCP2_CRYPTO_LIBRARY NAMES ngtcp2_crypto_boringssl ngtcp2_crypto_boringssl_static
                                       HINTS ${DEPENDS_PATH}/lib
                                       ${${CORE_PLATFORM_LC}_SEARCH_CONFIG})
  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(NGTcp2
                                    REQUIRED_VARS NGTCP2_LIBRARY NGTCP2_CRYPTO_LIBRARY NGTCP2_INCLUDE_DIR
                                    VERSION_VAR NGTCP2_VERSION)

  if(NGTCP2_FOUND)
    # Core ngtcp2 library
    add_library(NGTcp2::NGTcp2 UNKNOWN IMPORTED)
    set_target_properties(NGTcp2::NGTcp2 PROPERTIES
                                         IMPORTED_LOCATION "${NGTCP2_LIBRARY}"
                                         INTERFACE_INCLUDE_DIRECTORIES "${NGTCP2_INCLUDE_DIR}")

    # Crypto backend library (BoringSSL)
    add_library(NGTcp2::NGTcp2CryptoBoringSSL UNKNOWN IMPORTED)
    set_target_properties(NGTcp2::NGTcp2CryptoBoringSSL PROPERTIES
                                                        IMPORTED_LOCATION "${NGTCP2_CRYPTO_LIBRARY}"
                                                        INTERFACE_INCLUDE_DIRECTORIES "${NGTCP2_INCLUDE_DIR}"
                                                        INTERFACE_LINK_LIBRARIES "NGTcp2::NGTcp2")

    if(WIN32 OR WINDOWS_STORE)
      set_property(TARGET NGTcp2::NGTcp2 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS "NGTCP2_STATICLIB")
      set_property(TARGET NGTcp2::NGTcp2CryptoBoringSSL APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS "NGTCP2_STATICLIB")
    endif()
  else()
    if(NGTcp2_FIND_REQUIRED)
      message(FATAL_ERROR "NGTcp2 libraries were not found.")
    endif()
  endif()
endif()
