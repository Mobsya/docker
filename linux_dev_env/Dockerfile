FROM ubuntu:cosmic
MAINTAINER Corentin Jabot <corentinjabot@mobsya.org>

RUN apt-get -q update && apt-get install --no-install-recommends -q -y \
    wget \
    ca-certificates \
    build-essential \
    mesa-common-dev libgl1-mesa-dev \
    clang clang-format g++-multilib gdb \
    tar \
    git \
    cmake \
    ninja-build \
    libavahi-compat-libdnssd-dev \
    libudev-dev \
    libssl-dev \
    libfreetype6 \
    libfontconfig \
    libnss3 libasound2 libxtst6 libxrender1 libxi6 libxcursor1 libxcomposite1

# Qt
RUN wget -q http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run

COPY resources resources

RUN chmod +x ./qt-unified-linux-x64-online.run
RUN ./qt-unified-linux-x64-online.run --script resources/qt-installer-noninteractive.qs -platform minimal --logging-rules "ifw.*=true" --verbose

# Boost
RUN mkdir -p boost \
 && cd boost \
 && wget https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.gz -O boost.tar.gz \
 && tar -xzf boost.tar.gz --strip 1 \
 && ./bootstrap.sh \
 && ./b2 --prefix=/usr -j $(nproc --all) \
    install cxxflags=-fPIC cflags=-fPIC link=static threading=multi runtime-link=static \
    --with-chrono --with-system --with-thread --with-date_time --with-regex --with-serialization --with-program_options --with-filesystem \
 && cd .. && rm -rf boost

RUN echo "export CMAKE_PREFIX_PATH='$(realpath /opt/Qt/5.* | sort -r | head -n 1)/gcc_64/:${CMAKE_PREFIX_PATH}'" >> /etc/bash.bashrc