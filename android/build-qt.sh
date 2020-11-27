#!/bin/bash

CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
echo "Cores : $CORES"

cd qt-everywhere-src-${QT_VERSION}

# Taken and adapted from https://wiki.qt.io/Android and https://doc.qt.io/qt-5/android-building.html
# See also https://wiki.qt.io/Qt_5.15_Tools_and_Versions for configuration used internally by Qt team for their CI.
read -r -d '' QT_BUILD_CONFIG <<EOF
    -opensource
    -xplatform android-clang
    --disable-rpath
    -nomake tests
    -nomake examples
    -android-ndk ${ANDROID_NDK_PATH}
    -android-sdk ${ANDROID_SDK_PATH}
    -android-ndk-platform android-${API_LEVEL}
    -android-ndk-host linux-x86_64
    -skip qttranslations
    -skip qtserialport
    -no-dbus
    -opengl es2
    -no-warnings-are-errors
    -release
    --prefix=/qt
EOF

echo Configure Qt build with: ${QT_BUILD_CONFIG}
./configure ${QT_BUILD_CONFIG}

make -j$CORES
make install
