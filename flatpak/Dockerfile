# escape=`

FROM ubuntu:cosmic
MAINTAINER Corentin Jabot <corentinjabot@mobsya.org>

VOLUME /build
WORKDIR /build
ENV FLATPAK_GL_DRIVERS=dummy

RUN apt-get update && apt-get install -y ca-certificates bash flatpak-builder flatpak git ostree gsettings-desktop-schemas qemu binfmt-support qemu-user-static
RUN flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo