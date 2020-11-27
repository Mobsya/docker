#!/bin/bash

# Taken and adapted from https://wiki.qt.io/Android and https://doc.qt.io/qt-5/android-building.html

ndkVersion="r${NDK_VERSION}"    #  As of Qt 5.14, Qt 5.13.2+ and Qt 5.12.6+, the latest Android NDK (r20b or r21) is required.
sdkBuildToolsVersion="29.0.3"
sdkApiLevel="android-${API_LEVEL}"

# See https://developer.android.com/studio#command-tools
# and https://developer.android.com/studio/command-line
repository=https://dl.google.com/android/repository
toolsFile=commandlinetools-linux-6858069_latest.zip
toolsFolder=cmdline-tools
ndkFile=android-ndk-$ndkVersion-linux-x86_64.zip
ndkFolder=ndk

rm -rf $toolsFolder
rm -rf $ndkFolder

echo "Downloading SDK tools from $repository/$toolsFile"
wget -q $repository/$toolsFile
unzip -qq $toolsFile

echo "Downloading NDK from $repository/$ndkFile"
wget -q $repository/$ndkFile
unzip -qq $ndkFile -d $ndkFolder

rm $toolsFile
rm $ndkFile

echo "Installing SDK packages"
cd $toolsFolder/bin
ANDROID_SDK_PATH=/usr/lib/android-sdk
yes | ./sdkmanager --sdk_root=${ANDROID_SDK_PATH} --verbose --licenses
yes | ./sdkmanager --sdk_root=${ANDROID_SDK_PATH} --update
yes | ./sdkmanager --sdk_root=${ANDROID_SDK_PATH} "platforms;$sdkApiLevel" "platform-tools" "build-tools;$sdkBuildToolsVersion"
echo "Provisioning complete. Here's the list of packages:"
./sdkmanager --sdk_root=${ANDROID_SDK_PATH}  --list
