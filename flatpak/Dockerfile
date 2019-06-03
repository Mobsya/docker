# escape=`

FROM ubuntu:cosmic
MAINTAINER Corentin Jabot <corentinjabot@mobsya.org>

VOLUME /build
WORKDIR /build
ENV FLATPAK_GL_DRIVERS=dummy

RUN apt-get update && apt-get install -y ca-certificates bash flatpak-builder flatpak git ostree gsettings-desktop-schemas qemu binfmt-support qemu-user-static
RUN flatpak remote-add flathub https://dl.flathub.org/repo/flathub.flatpakrepo && flatpak install flathub org.kde.Sdk/x86_64/5.12 -y `
&& flatpak install flathub org.kde.Platform/x86_64/5.12 -y `
&& flatpak install flathub org.kde.Sdk/arm/5.12 -y `
&& flatpak install flathub org.kde.Platform/arm/5.12 -y `
&& flatpak install flathub org.kde.Sdk/aarch64/5.12 -y `
&& flatpak install flathub org.kde.Platform/aarch64/5.12 -y `
