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
        arch_build_folder=${BUILD_DIR}/${build_type}/${arch}/android-${THYMIO_BUILD_API_LEVEL}
        multi_arch_build_folder=${BUILD_DIR}/${build_type}/multi-abi/android-${THYMIO_BUILD_API_LEVEL}
        mkdir -p ${arch_build_folder}
        mkdir -p ${multi_arch_build_folder}/android-build
        mkdir -p ${multi_arch_build_folder}/aseba
        docker run --rm \
          --user ${user_id}:${group_id} \
        	-v ${SRC_DIR}:/src:rw \
        	-v ${arch_build_folder}:/build:rw \
        	mobsya/thymio-dev-env:${DEV_ENVIRONMENT_TAG} \
        	"cmake -DANDROID_PLATFORM=android-${THYMIO_BUILD_API_LEVEL} -DANDROID_ABI=${arch} -DCMAKE_TOOLCHAIN_FILE=\$ANDROID_NDK_PATH/build/cmake/android.toolchain.cmake -DCMAKE_FIND_ROOT_PATH=/qt -DCMAKE_BUILD_TYPE=$build_type -DBUILD_SHARED_LIBS=OFF -GNinja -S /src -B /build && cd /build && ninja -j $(nproc)"
        # Aggregate files from all ABIs into ${arch_build_folder}
        cp -R ${arch_build_folder}/android-build/* ${multi_arch_build_folder}/android-build/
        cp -R ${arch_build_folder}/aseba/* ${multi_arch_build_folder}/aseba/
        # Build multi-abi version of qtdeploy.json
        docker run --rm \
          --user ${user_id}:${group_id} \
          -v ${multi_arch_build_folder}:/build:rw \
          mobsya/thymio-dev-env:android$THYMIO_BUILD_API_LEVEL-ndk$NDK_VERSION-qt$QT_VERSION-cmake${CMAKE_VERSION} \
         "jq '.architectures = { \"arm64-v8a\":\"arm64-v8a\", \"armeabi-v7a\":\"armeabi-v7a\", \"x86\":\"x86\", \"x86_64\":\"x86_64\" }' /build/aseba/launcher/src/qtdeploy.json > /build/aseba/launcher/src/qtdeploy.json.tmp && mv /build/aseba/launcher/src/qtdeploy.json.tmp /build/aseba/launcher/src/qtdeploy.json"
    done
done

# Package multi-ABis (requires root access to /usr/lib)
multi_arch_build_folder=${BUILD_DIR}/Release/multi-abi/android-${THYMIO_BUILD_API_LEVEL}
android_target_platform="--android-platform android-${THYMIO_DEPLOYMENT_TARGET_API_LEVEL}"
build_type_option="--release"
docker run --rm \
  -v ${multi_arch_build_folder}:/build:rw \
  -e ANDROID_TARGET_SDK_VERSION=${THYMIO_DEPLOYMENT_TARGET_API_LEVEL} \
  mobsya/thymio-dev-env:android$THYMIO_BUILD_API_LEVEL-ndk$NDK_VERSION-qt$QT_VERSION-cmake${CMAKE_VERSION} \
 "/qt/bin/androiddeployqt --input /build/aseba/launcher/src/qtdeploy.json --output /build/android-build --aab ${build_type_option} ${android_target_platform}"
# Set permissions
docker run --rm \
  -v ${multi_arch_build_folder}:/build:rw \
  mobsya/thymio-dev-env:android$THYMIO_BUILD_API_LEVEL-ndk$NDK_VERSION-qt$QT_VERSION-cmake${CMAKE_VERSION} \
  "chown -R ${user_id}:${group_id} /build"
