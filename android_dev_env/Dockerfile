#escape = `

FROM ubuntu:cosmic as stage1
ARG TARGET_ARCH=armeabi-v7a
RUN apt-get update && apt-get install unzip wget openjdk-8-jre openjdk-8-jdk build-essential perl python -y --no-install-recommends
RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
RUN wget -q https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN mkdir -p /android/sdk/ && cd /android/sdk/ && unzip /sdk-tools-linux-4333796.zip
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
RUN yes | /android/sdk/tools/bin/sdkmanager --install tools "ndk;20.0.5594570" "platforms;android-22" platform-tools  "build-tools;29.0.0"
ENV ANDROID_NDK /android/sdk/ndk/20.0.5594570/
ENV ANDROID_SDK /android/sdk/
RUN wget -q https://download.qt.io/archive/qt/5.12/5.12.3/single/qt-everywhere-src-5.12.3.tar.xz
RUN apt-get install -y --no-install-recommends cmake git xz-utils g++ make
RUN tar xf qt-everywhere-src-5.12.3.tar.xz

COPY build-qt.sh /
RUN arch=$TARGET_ARCH bash -x build-qt.sh

FROM ubuntu:cosmic
RUN apt-get update && apt-get install doxygen pkg-config python3 git p7zip build-essential perl python npm nodejs ninja-build unzip wget openjdk-8-jre openjdk-8-jdk -y --no-install-recommends && apt-get clean
RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
COPY --from=stage1 /android/sdk /android/sdk
COPY --from=stage1 /Qt /Qt
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV ANDROID_NDK /android/sdk/ndk/20.0.5594570/
ENV ANDROID_SDK /android/sdk/
RUN mkdir ~/temp && cd ~/temp `
 && wget -q https://github.com/Kitware/CMake/releases/download/v3.14.5/cmake-3.14.5.tar.gz `
 && tar -xzvf cmake-3.14.5.tar.gz && cd cmake-3.14.5/ `
 && ./bootstrap && make && make install && cd && rm -rf ~/temp