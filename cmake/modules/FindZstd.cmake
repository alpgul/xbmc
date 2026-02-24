#.rst:
# FindZstd
# ----------
# Finds the Zstd (Zstandard) library
#
# This will define the following target:
#
#    Zstd::Zstd   - The Zstd library

if(NOT TARGET Zstd::Zstd)
  find_package(PkgConfig)
  if(PKG_CONFIG_FOUND AND NOT (WIN32 OR WINDOWSSTORE))
    pkg_check_modules(ZSTD libzstd QUIET)

    find_library(ZSTD_LIBRARY NAMES zstd zstd_static
                               HINTS ${ZSTD_LIBDIR})

    set(ZSTD_INCLUDE_DIR ${ZSTD_INCLUDEDIR})
  else()
    # Manual search for headers and libraries
    find_path(ZSTD_INCLUDE_DIR NAMES zstd.h
                               HINTS ${DEPENDS_PATH}/include
                               ${${CORE_PLATFORM_LC}_SEARCH_CONFIG})
                               
    find_library(ZSTD_LIBRARY NAMES zstd zstd_static
                               HINTS ${DEPENDS_PATH}/lib
                               ${${CORE_PLATFORM_LC}_SEARCH_CONFIG})
  endif()

  include(FindPackageHandleStandardArgs)
  # Handle the REQUIRED and QUIET arguments and set Zstd_FOUND
  find_package_handle_standard_args(Zstd
                                    REQUIRED_VARS ZSTD_LIBRARY ZSTD_INCLUDE_DIR
                                    VERSION_VAR ZSTD_VERSION)

  if(ZSTD_FOUND)
    # Create the imported target
    add_library(Zstd::Zstd UNKNOWN IMPORTED)

    set_target_properties(Zstd::Zstd PROPERTIES
                                     IMPORTED_LOCATION "${ZSTD_LIBRARY}"
                                     INTERFACE_INCLUDE_DIRECTORIES "${ZSTD_INCLUDE_DIR}")

    # Ensure proper static linking definitions on Windows platforms
    if(WIN32 OR WINDOWS_STORE)
      set_property(TARGET Zstd::Zstd APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS "ZSTD_STATICLIB")
    endif()
  else()
    # Provide a clear error message if the package is required but not found
    if(Zstd_FIND_REQUIRED)
      message(FATAL_ERROR "Zstd libraries were not found.")
    endif()
  endif()
endif()