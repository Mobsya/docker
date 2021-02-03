#!/bin/bash

# Setup env and load variable in current shell.
./setup-thymio-dev-env.sh && . .build-env

# Build all targets
build_types="Debug Release"
for build_type in $build_types; do
    architectures="armeabi-v7a arm64-v8a x86 x86_64"
    for arch in $architectures; do
        mkdir -p ${BUILD_DIR}/${build_type}/${arch}/android-${API_LEVEL}
        docker run --rm \
        	-v ${SRC_DIR}:/src:rw \
        	-v ${BUILD_DIR}/${build_type}/${arch}/android-${API_LEVEL}:/build:rw \
        	mobsya/thymio-dev-env:${DEV_ENVIRONMENT_TAG} \
        	"cmake -DANDROID_PLATFORM=android-${API_LEVEL} -DANDROID_ABI=${arch} -DCMAKE_TOOLCHAIN_FILE=\$ANDROID_NDK_PATH/build/cmake/android.toolchain.cmake -DCMAKE_FIND_ROOT_PATH=/qt -DCMAKE_BUILD_TYPE=$build_type -DBUILD_SHARED_LIBS=OFF -GNinja -S /src -B /build && cd /build && ninja -j $(nproc)"
    done
done
