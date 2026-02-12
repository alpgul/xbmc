#.rst:
# FindCurl
# --------
# Finds the Curl library
#
# This will define the following variables::
#
# CURL_FOUND - system has Curl
# CURL_INCLUDE_DIRS - the Curl include directory
# CURL_LIBRARIES - the Curl libraries
# CURL_DEFINITIONS - the Curl definitions
#
# and the following imported targets::
#
#   Curl::Curl   - The Curl library

if(PKG_CONFIG_FOUND)
  pkg_check_modules(PC_CURL libcurl QUIET)
endif()

find_path(CURL_INCLUDE_DIR NAMES curl/curl.h
                           PATHS ${PC_CURL_INCLUDEDIR})
find_library(CURL_LIBRARY NAMES curl libcurl libcurl_imp
                          PATHS ${PC_CURL_LIBDIR})

set(CURL_VERSION ${PC_CURL_VERSION})

set(CURL_LIB_TYPE SHARED)
set(CURL_LDFLAGS ${PC_CURL_LDFLAGS})

# check if curl is statically linked
if(${CURL_LIBRARY} MATCHES ".+\\.a$" AND PC_CURL_STATIC_LDFLAGS)
  set(CURL_LIB_TYPE STATIC)
  set(CURL_LDFLAGS ${PC_CURL_STATIC_LDFLAGS})

  # nghttp2 (HTTP/2)
  pkg_check_modules(PC_NGHTTP2 libnghttp2 QUIET)
  find_library(NGHTTP2_LIBRARY NAMES libnghttp2 nghttp2
                               PATHS ${PC_NGHTTP2_LIBDIR})

  # c-ares (async DNS resolver)
  pkg_check_modules(PC_CARES libcares QUIET)
  find_library(CARES_LIBRARY NAMES libcares cares
                             PATHS ${PC_CARES_LIBDIR})

  # brotli (content decoding)
  pkg_check_modules(PC_BROTLIDEC libbrotlidec QUIET)
  find_library(BROTLIDEC_LIBRARY NAMES libbrotlidec brotlidec
                                 PATHS ${PC_BROTLIDEC_LIBDIR})
  pkg_check_modules(PC_BROTLICOMMON libbrotlicommon QUIET)
  find_library(BROTLICOMMON_LIBRARY NAMES libbrotlicommon brotlicommon
                                    PATHS ${PC_BROTLICOMMON_LIBDIR})

  # zstd (content decoding)
  pkg_check_modules(PC_ZSTD libzstd QUIET)
  find_library(ZSTD_LIBRARY NAMES libzstd zstd
                            PATHS ${PC_ZSTD_LIBDIR})

  # ngtcp2 + nghttp3 (HTTP/3 QUIC)
  pkg_check_modules(PC_NGTCP2 libngtcp2 QUIET)
  find_library(NGTCP2_LIBRARY NAMES libngtcp2 ngtcp2
                              PATHS ${PC_NGTCP2_LIBDIR})
  pkg_check_modules(PC_NGTCP2_CRYPTO_BORINGSSL libngtcp2_crypto_boringssl QUIET)
  find_library(NGTCP2_CRYPTO_BORINGSSL_LIBRARY NAMES libngtcp2_crypto_boringssl ngtcp2_crypto_boringssl
                                               PATHS ${PC_NGTCP2_CRYPTO_BORINGSSL_LIBDIR})
  pkg_check_modules(PC_NGHTTP3 libnghttp3 QUIET)
  find_library(NGHTTP3_LIBRARY NAMES libnghttp3 nghttp3
                               PATHS ${PC_NGHTTP3_LIBDIR})

  # BoringSSL (installed under <prefix>/lib/boringssl/)
  # NO_DEFAULT_PATH prevents picking up regular OpenSSL from <prefix>/lib/
  find_library(BORINGSSL_SSL_LIBRARY NAMES ssl libssl
                                     PATHS ${PC_CURL_LIBDIR}/boringssl
                                           ${PC_CURL_PREFIX}/lib/boringssl
                                     NO_DEFAULT_PATH)
  find_library(BORINGSSL_CRYPTO_LIBRARY NAMES crypto libcrypto
                                        PATHS ${PC_CURL_LIBDIR}/boringssl
                                              ${PC_CURL_PREFIX}/lib/boringssl
                                        NO_DEFAULT_PATH)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Curl
                                  REQUIRED_VARS CURL_LIBRARY CURL_INCLUDE_DIR
                                  VERSION_VAR CURL_VERSION)

if(CURL_FOUND)
  set(CURL_INCLUDE_DIRS ${CURL_INCLUDE_DIR})
  set(CURL_LIBRARIES ${CURL_LIBRARY})

  # Append static dependencies in correct link order
  foreach(_dep_lib NGHTTP2_LIBRARY NGHTTP3_LIBRARY NGTCP2_LIBRARY
                   NGTCP2_CRYPTO_BORINGSSL_LIBRARY CARES_LIBRARY
                   BROTLIDEC_LIBRARY BROTLICOMMON_LIBRARY ZSTD_LIBRARY
                   BORINGSSL_SSL_LIBRARY BORINGSSL_CRYPTO_LIBRARY)
    if(${_dep_lib})
      list(APPEND CURL_LIBRARIES ${${_dep_lib}})
    endif()
  endforeach()

  if(NOT TARGET Curl::Curl)
    add_library(Curl::Curl ${CURL_LIB_TYPE} IMPORTED)
    set_target_properties(Curl::Curl PROPERTIES
                                     IMPORTED_LOCATION "${CURL_LIBRARY}"
                                     INTERFACE_INCLUDE_DIRECTORIES "${CURL_INCLUDE_DIR}")
    if(CURL_LIB_TYPE STREQUAL "STATIC")
      # For static linking, propagate all dependencies via INTERFACE_LINK_LIBRARIES
      set(_curl_iface_libs "")
      foreach(_dep_lib NGHTTP2_LIBRARY NGHTTP3_LIBRARY NGTCP2_LIBRARY
                       NGTCP2_CRYPTO_BORINGSSL_LIBRARY CARES_LIBRARY
                       BROTLIDEC_LIBRARY BROTLICOMMON_LIBRARY ZSTD_LIBRARY
                       BORINGSSL_SSL_LIBRARY BORINGSSL_CRYPTO_LIBRARY)
        if(${_dep_lib})
          list(APPEND _curl_iface_libs ${${_dep_lib}})
        endif()
      endforeach()
      if(_curl_iface_libs)
        set_target_properties(Curl::Curl PROPERTIES
                                         INTERFACE_LINK_LIBRARIES "${_curl_iface_libs}")
      endif()
    endif()
    if(HAS_CURL_STATIC)
        set_target_properties(Curl::Curl PROPERTIES
                                         INTERFACE_COMPILE_DEFINITIONS HAS_CURL_STATIC=1)
    endif()
  endif()
endif()

mark_as_advanced(CURL_INCLUDE_DIR CURL_LIBRARY CURL_LDFLAGS)
