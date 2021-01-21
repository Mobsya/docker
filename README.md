# Docker Environments for Mobsya CI

This repository contains several Docker files that provide a clean way to compile the Thymio Suite softwares as well as Qt for Android required for building Thymio.

NB: As of today the only supported platform is Android.

## Available Images

### mobsya/qt-builder

This image serves as a base image for the derived images qt-builder and thymio-dev-env targeting the Android platform.

### mobsya/android-sdk

This image provides a clean way to build Qt on a specific platform with a specific tool chain. The image also contains the built version of Qt located in '/qt'.

Each tag gives the platform, the tool chain version and the tag for the built version of Qt.


### mobsya/thymio-dev-env

This image provides a clean, self-container development environment for building Thymio Suite on a specific platform with a specific tool chain.

Each tag gives the platform, the tool chain version and the tag for the built version of Qt. The latest part of the tag gives the desired version of CMake.

Before building the Thymio Suite for the very first time, you need to deploy the JavaScript applications' assets into your source root like this:

```bash
# Build environment
SRC_DIR=$(pwd)/aseba

# Download assets into ${SRC_DIR}
scratch_version="v20201116.1"
scratch_url="https://github.com/Mobsya/scratch-gui/releases/download/${scratch_version}/scratch-gui.tar.gz"
vpl3_url="https://github.com/Mobsya/ci-data/releases/download/data/vpl3-thymio-suite.tar.gz"
wget ${scratch_url} && tar xzf scratch-gui.tar.gz -C ${SRC_DIR} && rm scratch-gui.tar.gz
wget ${vpl3_url} && tar xzf vpl3-thymio-suite.tar.gz -C ${SRC_DIR} && rm vpl3-thymio-suite.tar.gz
```

The image provides two volumes for its containers:

* /src: for mounting your local source code from the host into the container
* /build: for storing the files resulting from build commands

It is strongly suggested using an out of tree build strategy targeting the /build volume of the container in order to keep the source code clean. For instance, you may use -S and -B options of cmake. Here is an example for building just one target:

```bash
# Build environment
SRC_DIR=$(pwd)/aseba
BUILD_DIR=$(pwd)/aseba-build
API_LEVEL=21
DEV_ENVIRONMENT_TAG=android${API_LEVEL}-ndk21-qt5.15.2-cmake3.19.3

# Build target
build_type=Debug
arch=x86_64

# Create build directory on host
mkdir -p ${BUILD_DIR}/${build_type}/${arch}/android-${API_LEVEL}

# Run the build of ${SRC_DIR} with the container
docker run --rm \
    -v ${SRC_DIR}:/src:rw \
    -v ${BUILD_DIR}/${build_type}/${arch}/android-${API_LEVEL}:/build:rw \
    mobsya/thymio-dev-env:${DEV_ENVIRONMENT_TAG} \
    "cmake -DANDROID_PLATFORM=android-${API_LEVEL} -DANDROID_ABI=${arch} -DCMAKE_TOOLCHAIN_FILE=\$ANDROID_NDK_PATH/build/cmake/android.toolchain.cmake -DCMAKE_FIND_ROOT_PATH=/qt -DCMAKE_BUILD_TYPE=$build_type -DBUILD_SHARED_LIBS=OFF -GNinja -S /src -B /build && cd /build && ninja -j $(nproc)"
```

The option `-v ${SRC_DIR}:/src:rw` indicates that the source folder of Thymio is mapped in the container from the source directory on the host, while the option `-v ${BUILD_DIR}/${build_type}/${arch}/android-${API_LEVEL}:/build:rw` indicates that a folder pointed by `${BUILD_DIR}/${build_type}/${arch}/android-${API_LEVEL}` will be mapped to the /build volume of the container. Thus, the container will write the resulting build onto the host.

Here is an example for building Thymio for several architectures (one build folder per targeted build type and architecture):

```bash
# Build environment
SRC_DIR=$(pwd)/aseba
BUILD_DIR=$(pwd)/aseba-build
API_LEVEL=21
DEV_ENVIRONMENT_TAG=android${API_LEVEL}-ndk21-qt5.15.2-cmake3.19.3

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
```



##  Building Images

Run the `build-docker-images.sh` script in order to build each image. Use `build-docker-images.sh --push` in order to push the generated images to the repository.

In order to upgrade the build environment, edit the `build-docker-images.sh` script and change the variables at the top of the file before running it.
