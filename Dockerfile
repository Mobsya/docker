FROM alpine:latest
MAINTAINER Corentin Jabot <corentinjabot@mobsya.org>

VOLUME /build
WORKDIR /build
ENV FLATPAK_GL_DRIVERS=dummy

RUN apk update && apk upgrade && apk add flatpak flatpak-builder git ostree gsettings-desktop-schemas
RUN flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo
RUN flatpak install flathub org.kde.Sdk//5.12 -y
