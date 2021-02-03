#!/bin/bash

if [ -z "$API_LEVEL" ]; then
  read -p "Enter the desired Android API level (Android build platform, e.g. 21, 24 or 28): " API_LEVEL
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

DEV_ENVIRONMENT_TAG=android${API_LEVEL}-ndk21-qt5.15.2-cmake3.19.3

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

echo API_LEVEL=$API_LEVEL > .env
echo DEV_ENVIRONMENT_TAG=$DEV_ENVIRONMENT_TAG  >> .env
echo SRC_DIR=$SRC_DIR >> .env
echo BUILD_DIR=$BUILD_DIR >> .env

echo --- Type . .env to source the environment variables.