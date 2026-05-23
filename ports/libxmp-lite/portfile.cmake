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
file(COPY "${SOURCE_PATH}/src/lite/libxmp-lite-config.cmake" DESTINATION "${LITE_SOURCE_ROOT}")
file(COPY "${SOURCE_PATH}/src/lite/libxmp-lite-config-version.cmake.autotools.in" DESTINATION "${LITE_SOURCE_ROOT}")
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

vcpkg_cmake_config_fixup(CONFIG_PATH cmake)

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libxmp-lite.pc")
    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
    file(COPY "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libxmp-lite.pc" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
endif()

file(INSTALL
    "${SOURCE_PATH}/docs/CREDITS"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
    RENAME copyright
)
