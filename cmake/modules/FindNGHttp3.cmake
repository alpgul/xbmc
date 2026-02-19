#.rst:
# FindNGHttp3
# ----------
# Finds the NGHttp3 library
#
# This will define the following target:
#
#   NGHttp3::NGHttp3   - The NGHttp3 library

if(NOT TARGET NGHttp3::NGHttp3)
  find_package(PkgConfig)
  if(PKG_CONFIG_FOUND AND NOT (WIN32 OR WINDOWSSTORE))
    pkg_check_modules(NGHTTP3 libnghttp3 QUIET)

    find_library(NGHTTP3_LIBRARY NAMES nghttp3_static nghttp3
                                 HINTS ${NGHTTP3_LIBDIR})

    set(NGHTTP3_INCLUDE_DIR ${NGHTTP3_INCLUDEDIR})
  else()

    find_path(NGHTTP3_INCLUDE_DIR NAMES nghttp3/nghttp3.h
                                  HINTS ${DEPENDS_PATH}/include
                                  ${${CORE_PLATFORM_LC}_SEARCH_CONFIG})
    find_library(NGHTTP3_LIBRARY NAMES nghttp3 nghttp3_static
                                 HINTS ${DEPENDS_PATH}/lib
                                 ${${CORE_PLATFORM_LC}_SEARCH_CONFIG})
  endif()

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(NGHttp3
                                    REQUIRED_VARS NGHTTP3_LIBRARY NGHTTP3_INCLUDE_DIR
                                    VERSION_VAR NGHTTP3_VERSION)

  if(NGHTTP3_FOUND)
    add_library(NGHttp3::NGHttp3 UNKNOWN IMPORTED)

    set_target_properties(NGHttp3::NGHttp3 PROPERTIES
                                           IMPORTED_LOCATION "${NGHTTP3_LIBRARY}"
                                           INTERFACE_INCLUDE_DIRECTORIES "${NGHTTP3_INCLUDE_DIR}")

    if(WIN32 OR WINDOWS_STORE)
      set_property(TARGET NGHttp3::NGHttp3 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS "NGHTTP3_STATICLIB")
    endif()
  else()
    if(NGHttp3_FIND_REQUIRED)
      message(FATAL_ERROR "NGHttp3 libraries were not found.")
    endif()
  endif()
endif()
