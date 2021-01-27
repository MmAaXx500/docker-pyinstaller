FROM --platform=amd64 debian:buster-slim

ARG OPENSSL_VERSION=1.1.1i
ARG PYTHON_VERSION=3.9.1

ENV OPENSSL_VERSION=${OPENSSL_VERSION}
ENV PYTHON_VERSION=${PYTHON_VERSION}

ENV OPENSSL_BUILD_ARG01='./Configure' 
ENV OPENSSL_BUILD_ARG02='--prefix=/usr/local'
ENV OPENSSL_BUILD_ARG03='linux-generic64'
ENV OPENSSL_BUILD_ARG04='shared'
ENV OPENSSL_BUILD_ARG05='zlib'

ENV PYTHON_BUILD_ARG01='./configure'
ENV PYTHON_BUILD_ARG02='--enable-optimizations'
ENV PYTHON_BUILD_ARG03='--with-lto'
ENV PYTHON_BUILD_ARG04='--enable-shared'
ENV PYTHON_BUILD_ARG05='--enable-ipv6'

ENV BUILD_DEPS='autoconf automake autopoint autotools-dev bsdmainutils debhelper dh-autoreconf \
    dh-strip-nondeterminism distro-info-data docbook-xml docbook-xsl docutils-common dwz file \
    gettext gettext-base groff-base intltool-debian libarchive-zip-perl libbsd0 libcroco3 libelf1 \
    libfile-stripnondeterminism-perl libgc1c2 libglib2.0-0 libgpm2 libicu63 libmagic-mgc libmagic1 \
    libncurses6 libpipeline1 libpython3-stdlib libpython3.7-minimal libpython3.7-stdlib libsigsegv2 \
    libtool libuchardet0 libxml2 libxslt1.1 lsb-release m4 man-db po-debconf python3 python3-docutils \
    python3-minimal python3-roman python3.7 python3.7-minimal sensible-utils sgml-base sgml-data w3m \
    xml-core xsltproc'
ENV EXTRA_BUILD_DEPS='build-essential libbz2-dev libffi-dev libgdbm-compat-dev libgdbm-dev liblzma-dev \
    libncursesw5-dev libreadline-dev libsqlite3-dev tk-dev uuid-dev'
ENV RUN_DEPS='binutils blt libbz2-1.0 libc6 libdb5.3 libffi6 liblzma5 libmpdec2 libncursesw6 \
    libreadline7 libsqlite3-0 libtcl8.6 libtinfo6 libtk8.6 libuuid1 libx11-6 mime-support tix'
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
