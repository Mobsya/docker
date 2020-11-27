#!/bin/bash

set -e

start_time=$(date)

QT_BASE_VERSION=5.15
QT_PATCH_NUMBER=2
QT_API_LEVEL=28
THYMIO_API_LEVEL=23    # SDK API 21 is compatible with Android 5 Lollipop
NDK_VERSION=21  # As of Qt 5.14, Qt 5.13.2+ and Qt 5.12.6+, the latest Android NDK (r20b or r21) is required.

echo --- Installing Android SDK with API level $QT_API_LEVEL and $THYMIO_API_LEVEL, and NDK version $NDK_VERSION
docker build -t mobsya/android-sdk:android${QT_API_LEVEL}-ndk${NDK_VERSION} --build-arg NDK_VERSION=${NDK_VERSION} --build-arg API_LEVEL=${QT_API_LEVEL} -f Dockerfile.android-sdk .
docker build -t mobsya/android-sdk:android${THYMIO_API_LEVEL}-ndk${NDK_VERSION} --build-arg NDK_VERSION=${NDK_VERSION} --build-arg API_LEVEL=${THYMIO_API_LEVEL} -f Dockerfile.android-sdk .

echo --- Building Qt ${QT_BASE_VERSION}.${QT_PATCH_NUMBER} for Android with API level $QT_API_LEVEL, and NDK version $NDK_VERSION
#docker build -t mobsya/qt-builder:android${QT_API_LEVEL}-ndk${NDK_VERSION}-qt${QT_BASE_VERSION}.${QT_PATCH_NUMBER} --build-arg NDK_VERSION=${NDK_VERSION} --build-arg API_LEVEL=${QT_API_LEVEL} --build-arg QT_BASE_VERSION=${QT_BASE_VERSION} --build-arg QT_PATCH_NUMBER=${QT_PATCH_NUMBER} -f Dockerfile.qt-builder .

echo --- Creating development environment for Qt ${QT_BASE_VERSION}.${QT_PATCH_NUMBER}
docker build -t mobsya/thymio-dev-env:android${THYMIO_API_LEVEL}-ndk${NDK_VERSION}-qt${QT_BASE_VERSION}.${QT_PATCH_NUMBER} --build-arg NDK_VERSION=${NDK_VERSION} --build-arg QT_API_LEVEL=${QT_API_LEVEL} --build-arg THYMIO_API_LEVEL=${THYMIO_API_LEVEL} --build-arg QT_BASE_VERSION=${QT_BASE_VERSION} --build-arg QT_PATCH_NUMBER=${QT_PATCH_NUMBER} -f Dockerfile.thymio-dev-env .

echo Build of images started at: $start_time
echo Build of images ended at:   $(date)

echo Images generated:
echo - mobsya/android-sdk:android${QT_API_LEVEL}-ndk${NDK_VERSION}
echo - mobsya/android-sdk:android${THYMIO_API_LEVEL}-ndk${NDK_VERSION}
echo - mobsya/qt-builder:android${QT_API_LEVEL}-ndk${NDK_VERSION}-qt${QT_BASE_VERSION}.${QT_PATCH_NUMBER}
echo - mobsya/thymio-dev-env:android${THYMIO_API_LEVEL}-ndk${NDK_VERSION}-qt${QT_BASE_VERSION}.${QT_PATCH_NUMBER}

if [ "$1" == "--push" ]; then
    docker push mobsya/android-sdk:android${QT_API_LEVEL}-ndk${NDK_VERSION} \
        && docker push mobsya/android-sdk:android${THYMIO_API_LEVEL}-ndk${NDK_VERSION} \
        && docker push mobsya/qt-builder:android${QT_API_LEVEL}-ndk${NDK_VERSION}-qt${QT_BASE_VERSION}.${QT_PATCH_NUMBER} \
        && docker push mobsya/thymio-dev-env:android${THYMIO_API_LEVEL}-ndk${NDK_VERSION}-qt${QT_BASE_VERSION}.${QT_PATCH_NUMBER}
else
    echo --- Images were not pushed. You should invoke $(basename "$0") with --push option in order to push the images to the Docker repository.
fi
