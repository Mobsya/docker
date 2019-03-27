FROM ubuntu:cosmic
MAINTAINER Corentin Jabot <corentinjabot@mobsya.org>

VOLUME /build
WORKDIR /build
ENV FLATPAK_GL_DRIVERS=dummy

RUN apt-get update && apt-get install -y ca-certificates bash flatpak-builder flatpak git ostree gsettings-desktop-schemas
RUN flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo
RUN flatpak install flathub org.kde.Sdk//5.12 -y
RUN flatpak install flathub org.kde.Platform/x86_64/5.12 -y
