#!/bin/bash

# Setup env and load variable in current shell.
./setup-thymio-dev-env.sh && . .build-env

user_id=$(id --user)
group_id=$(id --group)

# Build all targets
build_types="Debug Release"
for build_type in $build_types; do
    architectures="armeabi-v7a arm64-v8a x86 x86_64"
    for arch in $architectures; do
        echo --- Handle build for: ${build_type}, ${arch}, android-${THYMIO_BUILD_API_LEVEL}
        arch_build_folder=${BUILD_DIR}/${build_type}/${arch}/android-${THYMIO_BUILD_API_LEVEL}

        echo --- Prepare build folders
        mkdir -p ${arch_build_folder}

        echo --- Build from source code for current ABI
        docker run --rm \
          --user ${user_id}:${group_id} \
        	-v ${SRC_DIR}:/src:rw \
        	-v ${arch_build_folder}:/build:rw \
        	mobsya/thymio-dev-env:${DEV_ENVIRONMENT_TAG} \
        	"cmake -DANDROID_PLATFORM=android-${THYMIO_BUILD_API_LEVEL} -DANDROID_ABI=${arch} -DCMAKE_TOOLCHAIN_FILE=\$ANDROID_NDK_PATH/build/cmake/android.toolchain.cmake -DCMAKE_FIND_ROOT_PATH=/qt -DCMAKE_BUILD_TYPE=$build_type -DBUILD_SHARED_LIBS=OFF -GNinja -S /src -B /build && cd /build && ninja -j $(nproc)"
    done

    if [ "$1" == "--package" ]; then
      ./package-thymio.sh
    fi
done
