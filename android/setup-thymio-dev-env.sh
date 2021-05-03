#!/bin/bash

echo "===== Configuration ====="
QT_VERSION=5.15.2
NDK_VERSION=21        # As of Qt 5.14, Qt 5.13.2+ and Qt 5.12.6+, the latest Android NDK (r20b or r21) is required.
CMAKE_VERSION=3.19.7
THYMIO_DEPLOYMENT_TARGET_API_LEVEL=30
echo "-------------------------"

if [ -z "$THYMIO_BUILD_API_LEVEL" ]; then
  read -p "Enter the desired Android API level (Android build platform, e.g. 21, 24, 28 or 29): " THYMIO_BUILD_API_LEVEL
fi
if [ ! -f "$SRC_DIR/CMakeLists.txt" ]; then
  echo --- "$SRC_DIR/CMakeLists.txt" not found. We need to define the source dir.
  SRC_DIR=
fi
if [ -z "$SRC_DIR" ]; then
  read -p "Enter path to the source root folder: " SRC_DIR
fi
if [ ! -f "$SRC_DIR/CMakeLists.txt" ]; then
  echo --- "$SRC_DIR/CMakeLists.txt" not found. Aborting.
  exit 1
fi
if [ -z "$BUILD_DIR" ]; then
  read -p "Enter path to the build root folder: " BUILD_DIR
fi
if [ -z "$BUILD_DIR" ]; then
  echo --- The build folder is undefined. Aborting.
  exit 1
fi

DEV_ENVIRONMENT_TAG=android${THYMIO_BUILD_API_LEVEL}and${THYMIO_DEPLOYMENT_TARGET_API_LEVEL}-ndk${NDK_VERSION}-qt${QT_VERSION}-cmake${CMAKE_VERSION}

if [ ! -d "$SRC_DIR/vpl3-thymio-suite" ]; then
  echo ---Download assets into ${SRC_DIR}
  vpl3_url="https://github.com/Mobsya/ci-data/releases/download/data/vpl3-thymio-suite.tar.gz"
  wget ${vpl3_url} && tar xzf vpl3-thymio-suite.tar.gz -C ${SRC_DIR}
  rm vpl3-thymio-suite.tar.gz
fi
if [ ! -d "$SRC_DIR/scratch" ]; then
  echo ---Download assets into ${SRC_DIR}
  scratch_version="v20201116.1"
  scratch_url="https://github.com/Mobsya/scratch-gui/releases/download/${scratch_version}/scratch-gui.tar.gz"
  wget ${scratch_url} && tar xzf scratch-gui.tar.gz -C ${SRC_DIR}
  rm scratch-gui.tar.gz
fi

(echo export THYMIO_DEPLOYMENT_TARGET_API_LEVEL=$THYMIO_DEPLOYMENT_TARGET_API_LEVEL; echo export THYMIO_BUILD_API_LEVEL=$THYMIO_BUILD_API_LEVEL; echo export DEV_ENVIRONMENT_TAG=$DEV_ENVIRONMENT_TAG; echo export SRC_DIR=$SRC_DIR; echo export BUILD_DIR=$BUILD_DIR; echo export QT_VERSION=$QT_VERSION; echo export NDK_VERSION=$NDK_VERSION; echo export CMAKE_VERSION=$CMAKE_VERSION) > .build-env

echo --- Type . .build-env to source the environment variables.