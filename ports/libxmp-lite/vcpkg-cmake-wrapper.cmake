set(z_vcpkg_libxmp_lite_root "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}")
set(z_vcpkg_libxmp_lite_include_dir "${z_vcpkg_libxmp_lite_root}/include/libxmp-lite")
set(z_vcpkg_libxmp_lite_shared_implib_release "")
set(z_vcpkg_libxmp_lite_shared_implib_debug "")
set(z_vcpkg_libxmp_lite_static_lib_release "")
set(z_vcpkg_libxmp_lite_static_lib_debug "")

if(EXISTS "${z_vcpkg_libxmp_lite_root}/lib/libxmp-lite.lib")
    set(z_vcpkg_libxmp_lite_shared_implib_release "${z_vcpkg_libxmp_lite_root}/lib/libxmp-lite.lib")
elseif(EXISTS "${z_vcpkg_libxmp_lite_root}/lib/libxmp-lite.dll.a")
    set(z_vcpkg_libxmp_lite_shared_implib_release "${z_vcpkg_libxmp_lite_root}/lib/libxmp-lite.dll.a")
endif()

if(EXISTS "${z_vcpkg_libxmp_lite_root}/debug/lib/libxmp-lite.lib")
    set(z_vcpkg_libxmp_lite_shared_implib_debug "${z_vcpkg_libxmp_lite_root}/debug/lib/libxmp-lite.lib")
elseif(EXISTS "${z_vcpkg_libxmp_lite_root}/debug/lib/libxmp-lite.dll.a")
    set(z_vcpkg_libxmp_lite_shared_implib_debug "${z_vcpkg_libxmp_lite_root}/debug/lib/libxmp-lite.dll.a")
endif()

if(EXISTS "${z_vcpkg_libxmp_lite_root}/lib/libxmp-lite-static.lib")
    set(z_vcpkg_libxmp_lite_static_lib_release "${z_vcpkg_libxmp_lite_root}/lib/libxmp-lite-static.lib")
elseif(EXISTS "${z_vcpkg_libxmp_lite_root}/lib/libxmp-lite.a")
    set(z_vcpkg_libxmp_lite_static_lib_release "${z_vcpkg_libxmp_lite_root}/lib/libxmp-lite.a")
endif()

if(EXISTS "${z_vcpkg_libxmp_lite_root}/debug/lib/libxmp-lite-static.lib")
    set(z_vcpkg_libxmp_lite_static_lib_debug "${z_vcpkg_libxmp_lite_root}/debug/lib/libxmp-lite-static.lib")
elseif(EXISTS "${z_vcpkg_libxmp_lite_root}/debug/lib/libxmp-lite.a")
    set(z_vcpkg_libxmp_lite_static_lib_debug "${z_vcpkg_libxmp_lite_root}/debug/lib/libxmp-lite.a")
endif()

if(NOT TARGET "libxmp-lite::xmp_lite_shared"
        AND NOT z_vcpkg_libxmp_lite_shared_implib_release STREQUAL ""
        AND EXISTS "${z_vcpkg_libxmp_lite_root}/bin/libxmp-lite.dll")
    add_library("libxmp-lite::xmp_lite_shared" SHARED IMPORTED)
    set_target_properties("libxmp-lite::xmp_lite_shared" PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${z_vcpkg_libxmp_lite_include_dir}"
        IMPORTED_IMPLIB_RELEASE "${z_vcpkg_libxmp_lite_shared_implib_release}"
        IMPORTED_LOCATION_RELEASE "${z_vcpkg_libxmp_lite_root}/bin/libxmp-lite.dll"
        IMPORTED_IMPLIB_DEBUG "${z_vcpkg_libxmp_lite_shared_implib_debug}"
        IMPORTED_LOCATION_DEBUG "${z_vcpkg_libxmp_lite_root}/debug/bin/libxmp-lite.dll"
    )
endif()

if(NOT TARGET "libxmp-lite::xmp_lite_static"
        AND NOT z_vcpkg_libxmp_lite_static_lib_release STREQUAL "")
    add_library("libxmp-lite::xmp_lite_static" STATIC IMPORTED)
    set_target_properties("libxmp-lite::xmp_lite_static" PROPERTIES
        INTERFACE_COMPILE_DEFINITIONS "LIBXMP_STATIC"
        INTERFACE_INCLUDE_DIRECTORIES "${z_vcpkg_libxmp_lite_include_dir}"
        IMPORTED_LOCATION_RELEASE "${z_vcpkg_libxmp_lite_static_lib_release}"
        IMPORTED_LOCATION_DEBUG "${z_vcpkg_libxmp_lite_static_lib_debug}"
    )
endif()

if(TARGET "libxmp-lite::xmp_lite_shared" AND NOT TARGET "libxmp-lite::xmp_lite")
    add_library("libxmp-lite::xmp_lite" INTERFACE IMPORTED)
    set_target_properties("libxmp-lite::xmp_lite" PROPERTIES
        INTERFACE_LINK_LIBRARIES "libxmp-lite::xmp_lite_shared"
    )
elseif(TARGET "libxmp-lite::xmp_lite_static" AND NOT TARGET "libxmp-lite::xmp_lite")
    add_library("libxmp-lite::xmp_lite" INTERFACE IMPORTED)
    set_target_properties("libxmp-lite::xmp_lite" PROPERTIES
        INTERFACE_LINK_LIBRARIES "libxmp-lite::xmp_lite_static"
    )
endif()

if(TARGET "libxmp-lite::xmp_lite")
    set(libxmp_lite_FOUND TRUE)
else()
    set(libxmp_lite_FOUND FALSE)
endif()

unset(z_vcpkg_libxmp_lite_root)
unset(z_vcpkg_libxmp_lite_include_dir)
unset(z_vcpkg_libxmp_lite_shared_implib_release)
unset(z_vcpkg_libxmp_lite_shared_implib_debug)
unset(z_vcpkg_libxmp_lite_static_lib_release)
unset(z_vcpkg_libxmp_lite_static_lib_debug)
