FROM --platform=amd64 debian:jessie-slim

ARG OPENSSL_VERSION=1.1.1i
ARG PYTHON_VERSION=3.9.1

ENV OPENSSL_VERSION=${OPENSSL_VERSION}
ENV PYTHON_VERSION=${PYTHON_VERSION}

ENV OPENSSL_BUILD_ARG01='./Configure' 
ENV OPENSSL_BUILD_ARG02='--prefix=/usr/local'
ENV OPENSSL_BUILD_ARG03='linux-generic64'
ENV OPENSSL_BUILD_ARG04='no-afalgeng'
ENV OPENSSL_BUILD_ARG05='shared'
ENV OPENSSL_BUILD_ARG06='zlib'

ENV PYTHON_BUILD_ARG01='./configure'
ENV PYTHON_BUILD_ARG02='--with-lto'
ENV PYTHON_BUILD_ARG03='--enable-shared'
ENV PYTHON_BUILD_ARG04='--enable-ipv6'
ENV PYTHON_BUILD_ARG05='CPPFLAGS=-O3'

ENV BUILD_DEPS='bsdmainutils debhelper debiandoc-sgml dh-python docutils-common file gettext gettext-base groff-base intltool-debian \
    libasprintf0c2 libcroco3 libglib2.0-0 libhtml-parser-perl libhtml-tagset-perl libmagic1 \
    libpipeline1 libpython-stdlib libpython2.7-minimal libpython2.7-stdlib libpython3-stdlib libpython3.4-minimal \
    libpython3.4-stdlib libroman-perl libsgmls-perl libsp1c2 libtext-format-perl libunistring0 \
    liburi-perl libxml2 lsb-release man-db po-debconf python python-minimal python2.7 python2.7-minimal \
    python3 python3-docutils python3-minimal python3-roman python3.4 python3.4-minimal sgml-base sgml-data sgmlspl sp \
    xml-core'
ENV EXTRA_BUILD_DEPS='build-essential libbz2-dev libffi-dev libgdbm-dev liblzma-dev libncursesw5-dev libreadline-dev libsqlite3-dev tk-dev uuid-dev'
ENV RUN_DEPS='binutils blt libbz2-1.0 libdb5.3 libexpat1 libffi6 liblzma5 libmpdec2 \
    libncursesw5 libreadline6 libsqlite3-0 libtcl8.6 libtk8.6 libx11-6 mime-support tix'
ENV EXTRA='ca-certificates wget'

COPY Linux-stage1.sh .
RUN /bin/bash ./Linux-stage1.sh \
    && rm -f ./Linux-stage1.sh


ARG PIP_VER=21.0
ARG PYINSTALLER_VERSION=4.2
ARG SETUPTOOLS_VERSION=50.3.2
ARG WHEEL_VERSION=0.36.2

ENV PIP_VER=${PIP_VER}
ENV PYINSTALLER_VERSION=${PYINSTALLER_VERSION}
ENV SETUPTOOLS_VERSION=${SETUPTOOLS_VERSION}
ENV WHEEL_VERSION=${WHEEL_VERSION}

COPY Linux-stage2.sh .
RUN /bin/bash ./Linux-stage2.sh \
    && rm -f ./Linux-stage2.sh
