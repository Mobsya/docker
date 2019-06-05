# escape=`

FROM arm64v8/fedora:latest
MAINTAINER Corentin Jabot <corentinjabot@mobsya.org>

VOLUME /build
WORKDIR /build
ENV FLATPAK_GL_DRIVERS=dummy

RUN dnf update -y && dnf install -y flatpak flatpak-builder git-all sudo ccache gnupg && dnf clean all

RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN chmod u+s $(/bin/which bwrap) $(/bin/which flatpak) $(/bin/which flatpak-builder) /usr/local/libexec/flatpak-bwrap
RUN flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo