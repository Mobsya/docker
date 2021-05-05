#!/bin/bash

# Setup env and load variable in current shell.
./setup-thymio-dev-env.sh && . .build-env

user_id=$(id --user)
group_id=$(id --group)

# Build all targets
build_types="Debug Release"
for build_type in $build_types; do
    echo --- Prepare build folders
    multi_arch_build_folder=${BUILD_DIR}/${build_type}/multi-abi/android-${THYMIO_BUILD_API_LEVEL}
    mkdir -p ${multi_arch_build_folder}/android-build
    mkdir -p ${multi_arch_build_folder}/aseba

    architectures="armeabi-v7a arm64-v8a x86 x86_64"
    for arch in $architectures; do
        arch_build_folder=${BUILD_DIR}/${build_type}/${arch}/android-${THYMIO_BUILD_API_LEVEL}

        echo --- Copy files from current ABI into multi-ABIs folder
        cp -R ${arch_build_folder}/android-build/* ${multi_arch_build_folder}/android-build/
        cp -R ${arch_build_folder}/aseba/* ${multi_arch_build_folder}/aseba/
    done

    echo --- Build multi-ABIs version of qtdeploy.json and setup gradle config file as well as manifest.
    cp ${multi_arch_build_folder}/aseba/launcher/src/AndroidManifest.xml ${multi_arch_build_folder}/android-build/
    cp ${SRC_DIR}/android/qt-android-cmake/build.gradle.in ${multi_arch_build_folder}/android-build/build.gradle
    sed -i "s/@ANDROID_PLATFORM_LEVEL@/${THYMIO_DEPLOYMENT_TARGET_API_LEVEL}/" ${multi_arch_build_folder}/android-build/build.gradle
    docker run --rm \
      --user ${user_id}:${group_id} \
      -v ${multi_arch_build_folder}:/build:rw \
      mobsya/thymio-dev-env:${DEV_ENVIRONMENT_TAG} \
     "jq '.architectures = { \"arm64-v8a\":\"arm64-v8a\", \"armeabi-v7a\":\"armeabi-v7a\", \"x86\":\"x86\", \"x86_64\":\"x86_64\" }' /build/aseba/launcher/src/qtdeploy.json > /build/aseba/launcher/src/qtdeploy.json.tmp && mv /build/aseba/launcher/src/qtdeploy.json.tmp /build/aseba/launcher/src/qtdeploy.json"

    echo --- Package multi-ABIs
    # Requires root access for /usr/lib.
    android_target_platform="--android-platform android-${THYMIO_DEPLOYMENT_TARGET_API_LEVEL}"
    build_type_option="--${build_type,,}"
    docker run --rm \
      -v ${multi_arch_build_folder}:/build:rw \
      -e ANDROID_TARGET_SDK_VERSION=${THYMIO_DEPLOYMENT_TARGET_API_LEVEL} \
      mobsya/thymio-dev-env:${DEV_ENVIRONMENT_TAG} \
     "/qt/bin/androiddeployqt --input /build/aseba/launcher/src/qtdeploy.json --output /build/android-build --aab --verbose ${build_type_option} ${android_target_platform}"

    echo --- Set ownership to current user
    docker run --rm \
      -v ${multi_arch_build_folder}:/build:rw \
      mobsya/thymio-dev-env:${DEV_ENVIRONMENT_TAG} \
      "chown -R ${user_id}:${group_id} /build"
done
