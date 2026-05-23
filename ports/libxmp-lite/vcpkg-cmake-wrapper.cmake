if("${ARGS}" MATCHES "^libxmp_lite;")
    set(z_vcpkg_libxmp_lite_root "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}")
    set(z_vcpkg_libxmp_lite_include_dir "${z_vcpkg_libxmp_lite_root}/include/libxmp-lite")

    if(NOT TARGET "libxmp-lite::xmp_lite_shared"
            AND EXISTS "${z_vcpkg_libxmp_lite_root}/lib/libxmp-lite.lib"
            AND EXISTS "${z_vcpkg_libxmp_lite_root}/bin/libxmp-lite.dll")
        add_library("libxmp-lite::xmp_lite_shared" SHARED IMPORTED)
        set_target_properties("libxmp-lite::xmp_lite_shared" PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${z_vcpkg_libxmp_lite_include_dir}"
            IMPORTED_IMPLIB_RELEASE "${z_vcpkg_libxmp_lite_root}/lib/libxmp-lite.lib"
            IMPORTED_LOCATION_RELEASE "${z_vcpkg_libxmp_lite_root}/bin/libxmp-lite.dll"
            IMPORTED_IMPLIB_DEBUG "${z_vcpkg_libxmp_lite_root}/debug/lib/libxmp-lite.lib"
            IMPORTED_LOCATION_DEBUG "${z_vcpkg_libxmp_lite_root}/debug/bin/libxmp-lite.dll"
        )
    endif()

    if(NOT TARGET "libxmp-lite::xmp_lite_static"
            AND EXISTS "${z_vcpkg_libxmp_lite_root}/lib/libxmp-lite-static.lib")
        add_library("libxmp-lite::xmp_lite_static" STATIC IMPORTED)
        set_target_properties("libxmp-lite::xmp_lite_static" PROPERTIES
            INTERFACE_COMPILE_DEFINITIONS "LIBXMP_STATIC"
            INTERFACE_INCLUDE_DIRECTORIES "${z_vcpkg_libxmp_lite_include_dir}"
            IMPORTED_LOCATION_RELEASE "${z_vcpkg_libxmp_lite_root}/lib/libxmp-lite-static.lib"
            IMPORTED_LOCATION_DEBUG "${z_vcpkg_libxmp_lite_root}/debug/lib/libxmp-lite-static.lib"
        )
    endif()

    if(TARGET "libxmp-lite::xmp_lite_shared" OR TARGET "libxmp-lite::xmp_lite_static")
        set(libxmp_lite_FOUND TRUE)
    else()
        set(libxmp_lite_FOUND FALSE)
    endif()

    unset(z_vcpkg_libxmp_lite_root)
    unset(z_vcpkg_libxmp_lite_include_dir)
else()
    _find_package(${ARGS})
endif()
