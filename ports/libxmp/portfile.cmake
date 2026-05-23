vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libxmp/libxmp
    REF libxmp-4.7.0
    SHA512 AB7ED467A5FC968769CA8DEBBC648C1B86FCBFC95C5F9813CF6A47B35BC731009C1CBF09ECF4878F66C0903E70E68BC99EECE37EE5DA1A787D9C4FB711E9F790
    HEAD_REF master
)

set(LITE_SOURCE_ROOT "${CURRENT_BUILDTREES_DIR}/src/${PORT}-lite-root")
file(REMOVE_RECURSE "${LITE_SOURCE_ROOT}")
file(MAKE_DIRECTORY
    "${LITE_SOURCE_ROOT}/cmake"
    "${LITE_SOURCE_ROOT}/include/libxmp-lite"
)

file(COPY "${SOURCE_PATH}/src" DESTINATION "${LITE_SOURCE_ROOT}")
file(COPY "${SOURCE_PATH}/cmake/libxmp-checks.cmake" DESTINATION "${LITE_SOURCE_ROOT}/cmake")
file(COPY "${SOURCE_PATH}/libxmp.map" DESTINATION "${LITE_SOURCE_ROOT}")
file(COPY "${SOURCE_PATH}/src/lite/libxmp-lite.pc.in" DESTINATION "${LITE_SOURCE_ROOT}")
file(COPY "${SOURCE_PATH}/lite/CMakeLists.txt" DESTINATION "${LITE_SOURCE_ROOT}")
file(COPY "${SOURCE_PATH}/include/xmp.h" DESTINATION "${LITE_SOURCE_ROOT}/include/libxmp-lite")

file(WRITE "${LITE_SOURCE_ROOT}/cmake/libxmp-sources.cmake" [=[
set(LIBXMP_SRC_LIST
    src/lite/lite-virtual.c
    src/lite/lite-format.c
    src/lite/lite-period.c
    src/lite/lite-player.c
    src/lite/lite-read_event.c
    src/lite/lite-misc.c
    src/lite/lite-dataio.c
    src/lite/lite-lfo.c
    src/lite/lite-scan.c
    src/lite/lite-control.c
    src/lite/lite-filter.c
    src/lite/lite-effects.c
    src/lite/lite-mixer.c
    src/lite/lite-mix_all.c
    src/lite/lite-load_helpers.c
    src/lite/lite-load.c
    src/lite/lite-filetype.c
    src/lite/lite-hio.c
    src/lite/lite-smix.c
    src/lite/lite-memio.c
    src/lite/lite-rng.c
    src/lite/lite-win32.c
    src/lite/lite-flow.c
    src/lite/lite-common.c
    src/lite/lite-itsex.c
    src/lite/lite-sample.c
    src/lite/lite-xm_load.c
    src/lite/lite-mod_load.c
    src/lite/lite-s3m_load.c
    src/lite/lite-it_load.c
)
]=])

vcpkg_cmake_configure(
    SOURCE_PATH "${LITE_SOURCE_ROOT}"
    OPTIONS
        -DBUILD_SHARED=ON
        -DBUILD_STATIC=ON
        -DWITH_UNIT_TESTS=OFF
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/share/libxmp"
    "${CURRENT_PACKAGES_DIR}/share/libxmp-lite"
)

if(EXISTS "${CURRENT_PACKAGES_DIR}/include/libxmp-lite/xmp.h")
    file(COPY "${CURRENT_PACKAGES_DIR}/include/libxmp-lite/xmp.h" DESTINATION "${CURRENT_PACKAGES_DIR}/include")
endif()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/libxmp-lite")

if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/libxmp-lite.dll")
    file(RENAME "${CURRENT_PACKAGES_DIR}/bin/libxmp-lite.dll" "${CURRENT_PACKAGES_DIR}/bin/libxmp.dll")
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/libxmp-lite.pdb")
    file(RENAME "${CURRENT_PACKAGES_DIR}/bin/libxmp-lite.pdb" "${CURRENT_PACKAGES_DIR}/bin/libxmp.pdb")
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/libxmp-lite.lib")
    file(RENAME "${CURRENT_PACKAGES_DIR}/lib/libxmp-lite.lib" "${CURRENT_PACKAGES_DIR}/lib/libxmp.lib")
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/libxmp-lite-static.lib")
    file(RENAME "${CURRENT_PACKAGES_DIR}/lib/libxmp-lite-static.lib" "${CURRENT_PACKAGES_DIR}/lib/libxmp-static.lib")
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/bin/libxmp-lite.dll")
    file(RENAME "${CURRENT_PACKAGES_DIR}/debug/bin/libxmp-lite.dll" "${CURRENT_PACKAGES_DIR}/debug/bin/libxmp.dll")
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/bin/libxmp-lite.pdb")
    file(RENAME "${CURRENT_PACKAGES_DIR}/debug/bin/libxmp-lite.pdb" "${CURRENT_PACKAGES_DIR}/debug/bin/libxmp.pdb")
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/lib/libxmp-lite.lib")
    file(RENAME "${CURRENT_PACKAGES_DIR}/debug/lib/libxmp-lite.lib" "${CURRENT_PACKAGES_DIR}/debug/lib/libxmp.lib")
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/lib/libxmp-lite-static.lib")
    file(RENAME "${CURRENT_PACKAGES_DIR}/debug/lib/libxmp-lite-static.lib" "${CURRENT_PACKAGES_DIR}/debug/lib/libxmp-static.lib")
endif()

foreach(pc_file
    "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libxmp-lite.pc"
    "${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libxmp-lite.pc")
    if(EXISTS "${pc_file}")
        file(READ "${pc_file}" pc_contents)
        string(REPLACE "libxmp-lite" "libxmp" pc_contents "${pc_contents}")
        string(REPLACE "-lxmp-lite" "-lxmp" pc_contents "${pc_contents}")
        string(REPLACE "/libxmp-lite" "" pc_contents "${pc_contents}")
        string(REPLACE "Cflags: -I\${includedir}" "Cflags: -I\${includedir}" pc_contents "${pc_contents}")
        get_filename_component(pc_dir "${pc_file}" DIRECTORY)
        file(WRITE "${pc_dir}/libxmp.pc" "${pc_contents}")
        file(REMOVE "${pc_file}")
    endif()
endforeach()

file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/share/${PORT}")

file(INSTALL
    "${SOURCE_PATH}/docs/CREDITS"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
    RENAME copyright
)
