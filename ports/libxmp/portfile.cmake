vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libxmp/libxmp
    REF libxmp-4.7.0
    SHA512 AB7ED467A5FC968769CA8DEBBC648C1B86FCBFC95C5F9813CF6A47B35BC731009C1CBF09ECF4878F66C0903E70E68BC99EECE37EE5DA1A787D9C4FB711E9F790
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_LITE=ON
        -DBUILD_SHARED=ON
        -DBUILD_STATIC=ON
        -DWITH_UNIT_TESTS=OFF
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/lib/cmake/libxmp"
    "${CURRENT_PACKAGES_DIR}/debug/lib/cmake/libxmp"
)

if(EXISTS "${CURRENT_PACKAGES_DIR}/include/libxmp-lite/xmp.h")
    file(COPY "${CURRENT_PACKAGES_DIR}/include/libxmp-lite/xmp.h" DESTINATION "${CURRENT_PACKAGES_DIR}/include")
endif()

if(EXISTS "${CURRENT_PACKAGES_DIR}/share/libxmp-lite")
    file(RENAME "${CURRENT_PACKAGES_DIR}/share/libxmp-lite" "${CURRENT_PACKAGES_DIR}/share/libxmp")
endif()

if(EXISTS "${CURRENT_PACKAGES_DIR}/share/libxmp/libxmp-lite-config.cmake")
    file(RENAME
        "${CURRENT_PACKAGES_DIR}/share/libxmp/libxmp-lite-config.cmake"
        "${CURRENT_PACKAGES_DIR}/share/libxmp/libxmp-config.cmake"
    )
endif()

if(EXISTS "${CURRENT_PACKAGES_DIR}/share/libxmp/libxmp-lite-config-version.cmake")
    file(RENAME
        "${CURRENT_PACKAGES_DIR}/share/libxmp/libxmp-lite-config-version.cmake"
        "${CURRENT_PACKAGES_DIR}/share/libxmp/libxmp-config-version.cmake"
    )
endif()

foreach(target_file
    libxmp-lite-shared-targets.cmake
    libxmp-lite-shared-targets-debug.cmake
    libxmp-lite-shared-targets-release.cmake
    libxmp-lite-static-targets.cmake
    libxmp-lite-static-targets-debug.cmake
    libxmp-lite-static-targets-release.cmake)
    if(EXISTS "${CURRENT_PACKAGES_DIR}/share/libxmp/${target_file}")
        file(READ "${CURRENT_PACKAGES_DIR}/share/libxmp/${target_file}" target_contents)
        string(REPLACE "libxmp-lite::xmp_lite_shared" "libxmp::xmp_shared" target_contents "${target_contents}")
        string(REPLACE "libxmp-lite::xmp_lite_static" "libxmp::xmp_static" target_contents "${target_contents}")
        string(REPLACE "include/libxmp-lite" "include" target_contents "${target_contents}")
        string(REPLACE "libxmp-lite.lib" "libxmp.lib" target_contents "${target_contents}")
        string(REPLACE "libxmp-lite-static.lib" "libxmp-static.lib" target_contents "${target_contents}")
        string(REPLACE "bin/libxmp-lite.dll" "bin/libxmp.dll" target_contents "${target_contents}")
        string(REPLACE "debug/bin/libxmp-lite.dll" "debug/bin/libxmp.dll" target_contents "${target_contents}")

        set(output_name "${target_file}")
        string(REPLACE "libxmp-lite-" "libxmp-" output_name "${output_name}")
        file(WRITE "${CURRENT_PACKAGES_DIR}/share/libxmp/${output_name}" "${target_contents}")
        file(REMOVE "${CURRENT_PACKAGES_DIR}/share/libxmp/${target_file}")
    endif()
endforeach()

if(EXISTS "${CURRENT_PACKAGES_DIR}/share/libxmp/libxmp-config.cmake")
    file(WRITE "${CURRENT_PACKAGES_DIR}/share/libxmp/libxmp-config.cmake" [=[
set(libxmp_FOUND OFF)

if(EXISTS "${CMAKE_CURRENT_LISTDIR}/libxmp-shared-targets.cmake")
    include("${CMAKE_CURRENT_LISTDIR}/libxmp-shared-targets.cmake")
    set(libxmp_FOUND ON)
endif()

if(EXISTS "${CMAKE_CURRENT_LISTDIR}/libxmp-static-targets.cmake")
    include("${CMAKE_CURRENT_LISTDIR}/libxmp-static-targets.cmake")
    set(libxmp_FOUND ON)
endif()
]=])
endif()

if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libxmp-lite.pc")
    file(RENAME "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libxmp-lite.pc" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libxmp.pc")
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libxmp-lite.pc")
    file(RENAME "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libxmp-lite.pc" "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libxmp.pc")
endif()

file(INSTALL
    "${SOURCE_PATH}/docs/CREDITS"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
    RENAME copyright
)
