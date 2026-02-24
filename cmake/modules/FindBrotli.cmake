#.rst:
# FindBrotli
# ----------
# Finds the Brotli decompression libraries (common and decoder)
#
# This will define the following targets:
#
#   Brotli::Common  - The Brotli common library
#   Brotli::Decoder - The Brotli decoder library

if(NOT TARGET Brotli::Decoder)
  find_package(PkgConfig)
  if(PKG_CONFIG_FOUND AND NOT (WIN32 OR WINDOWSSTORE))
    pkg_check_modules(BROTLI_COMMON libbrotlicommon QUIET)
    pkg_check_modules(BROTLI_DECODER libbrotlidec QUIET)

    find_library(BROTLI_COMMON_LIBRARY NAMES brotlicommon-static brotlicommon
                                       HINTS ${BROTLI_COMMON_LIBDIR})
    find_library(BROTLI_DECODER_LIBRARY NAMES brotlidec-static brotlidec
                                        HINTS ${BROTLI_DECODER_LIBDIR})

    set(BROTLI_INCLUDE_DIR ${BROTLI_DECODER_INCLUDEDIR})
  else()
    find_path(BROTLI_INCLUDE_DIR NAMES brotli/decode.h
                                 HINTS ${DEPENDS_PATH}/include
                                 ${${CORE_PLATFORM_LC}_SEARCH_CONFIG})
    find_library(BROTLI_COMMON_LIBRARY NAMES brotlicommon brotlicommon-static
                                       HINTS ${DEPENDS_PATH}/lib
                                       ${${CORE_PLATFORM_LC}_SEARCH_CONFIG})
    find_library(BROTLI_DECODER_LIBRARY NAMES brotlidec brotlidec-static
                                        HINTS ${DEPENDS_PATH}/lib
                                        ${${CORE_PLATFORM_LC}_SEARCH_CONFIG})
  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(Brotli
                                    REQUIRED_VARS BROTLI_DECODER_LIBRARY BROTLI_COMMON_LIBRARY BROTLI_INCLUDE_DIR
                                    VERSION_VAR BROTLI_DECODER_VERSION)

  if(Brotli_FOUND)
    add_library(Brotli::Common UNKNOWN IMPORTED)
    set_target_properties(Brotli::Common PROPERTIES
                                         IMPORTED_LOCATION "${BROTLI_COMMON_LIBRARY}"
                                         INTERFACE_INCLUDE_DIRECTORIES "${BROTLI_INCLUDE_DIR}")

    add_library(Brotli::Decoder UNKNOWN IMPORTED)
    set_target_properties(Brotli::Decoder PROPERTIES
                                          IMPORTED_LOCATION "${BROTLI_DECODER_LIBRARY}"
                                          INTERFACE_INCLUDE_DIRECTORIES "${BROTLI_INCLUDE_DIR}"
                                          INTERFACE_LINK_LIBRARIES "Brotli::Common")

    if(WIN32 OR WINDOWSSTORE)
      set_property(TARGET Brotli::Common APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS "BROTLI_STATIC_FIXED")
      set_property(TARGET Brotli::Decoder APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS "BROTLI_STATIC_FIXED")
    endif()
  else()
    if(Brotli_FIND_REQUIRED)
      message(FATAL_ERROR "Brotli libraries were not found.")
    endif()
  endif()
endif()
