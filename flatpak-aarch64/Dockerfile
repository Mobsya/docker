# escape=`

FROM arm64v8/ubuntu:cosmic
MAINTAINER Corentin Jabot <corentinjabot@mobsya.org>

VOLUME /build
WORKDIR /build
COPY --from=multiarch/qemu-user-static:x86_64-aarch64 /usr/bin/qemu-* /usr/bin
ENV FLATPAK_GL_DRIVERS=dummy
RUN apt-get update && apt-get install -y ca-certificates bash flatpak-builder flatpak git ostree gsettings-desktop-schemas
RUN flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo