echo $arch
case $arch in
    armeabi-v7a)
        toolchain="arm-linux-androideabi" ;;
    arm64-v8a)
        toolchain="aarch64-linux-android" ;;
    x86_64)
        toolchain="x86_64-linux-android" ;;
esac
CORES=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || sysctl -n hw.ncpu)
echo $CORES
cd $ANDROID_NDK/sources/cxx-stl/llvm-libc++/libs/arm64-v8a && ln -s libc++_shared.so libc++.so 2>/dev/null || true;
cd /qt-everywhere-src-5.12.3 &&  mkdir build_$arch && cd build_$arch
../configure -opensource -confirm-license \
-optimized-qmake \
-platform linux-g++ \
-xplatform android-clang --disable-rpath \
-nomake examples -nomake tests  \
-android-ndk $ANDROID_NDK -android-sdk $ANDROID_SDK \
-skip qtserialport \
-skip webengine \
-skip qtdoc \
-skip qtserialbus \
-skip qtscxml \
-skip qtremoteobjects \
-skip qtpurchasing \
-skip qtscript \
-skip qtspeech \
-android-ndk-host linux-x86_64 -android-toolchain-version 4.9 \
-android-ndk-platform android-23 \
-android-arch $arch \
-prefix /Qt/android_$arch \
-no-warnings-are-errors \
QMAKE_LFLAGS+= "-L$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/$toolchain/23/" \
 || (more config.log; exit 1)
 make && make install