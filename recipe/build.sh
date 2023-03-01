#!/bin/bash -x -e

declare -a CMAKE_PLATFORM_FLAGS
CMAKE_PLATFORM_FLAGS+=(-DCMAKE_FIND_ROOT_PATH="${PREFIX};${BUILD_PREFIX}/${HOST}/sysroot")
CMAKE_PLATFORM_FLAGS+=(-DCMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES:PATH="${BUILD_PREFIX}/${HOST}/sysroot/usr/include")

if [[ ${DEBUG_C} == yes ]]; then
  CMAKE_BUILD_TYPE=Debug
else
  CMAKE_BUILD_TYPE=Release
fi


export LDFLAGS="-lrt"
export PKG_CONFIG_PATH=${CONDA_PREFIX}/share/pkgconfig:${CONDA_PREFIX}/lib/pkgconfig:$PKG_CONFIG_PATH

env |sort

mkdir build
cd build
${CONDA_PREFIX}/bin/cmake --version
${CONDA_PREFIX}/bin/cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DSZ3_USE_BUNDLED_ZSTD=OFF \
  -DSZ3_DEBUG_TIMINGS=OFF "${CMAKE_PLATFORM_FLAGS[@]}" \
  "${SRC_DIR}"

${CONDA_PREFIX}/bin/make -j${CPU_COUNT}
${CONDA_PREFIX}/bin/make install PREFIX=${PREFIX}
