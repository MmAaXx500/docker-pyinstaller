#!/bin/bash

set -x
export DEBIAN_FRONTEND=noninteractive

dpkg --add-architecture i386
apt-get update -qy

if [[ ${WINEARCH} = win32 ]]
then
    apt-get install --no-install-recommends -qfy \
        wine32
else
    apt-get install --no-install-recommends -qfy \
        wine32 \
        wine64
fi

apt-get install --no-install-recommends -qfy \
    ca-certificates \
    fonts-wine \
    wget \
    winbind \
    wine \
    xvfb

apt-get clean
wget -nv https://raw.githubusercontent.com/Winetricks/winetricks/d7653d49599990efba0ba171ebbebd256fcf7cbd/src/winetricks
chmod +x winetricks
mv winetricks /usr/local/bin
