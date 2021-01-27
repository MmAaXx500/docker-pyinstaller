#!/bin/bash

runvar () {
    ARGARR=()
    eval 'ARGS=(${!'"$1"'@})'
    for p in "${ARGS[@]}"
    do
        ARGARR+=("${!p}")
    done
    "${ARGARR[@]}"
}

set -xe
export DEBIAN_FRONTEND=noninteractive

apt-get update -qy
apt-get install --no-install-recommends -qfy \
    ${BUILD_DEPS} \
    ${EXTRA_BUILD_DEPS} \
    ${RUN_DEPS} \
    ${EXTRA}

cd ~

wget -q https://www.openssl.org/source/openssl-"${OPENSSL_VERSION}".tar.gz
wget -q https://www.python.org/ftp/python/"${PYTHON_VERSION}"/Python-"${PYTHON_VERSION}".tgz


tar xf openssl-"${OPENSSL_VERSION}".tar.gz
tar xf Python-"${PYTHON_VERSION}".tgz

cd ~/openssl-"${OPENSSL_VERSION}"
runvar OPENSSL_BUILD_ARG
make -s -j"$(grep -c ^processor /proc/cpuinfo)"
make install_sw

ldconfig

cd ~/Python-"${PYTHON_VERSION}"
runvar PYTHON_BUILD_ARG
make -s -j"$(grep -c ^processor /proc/cpuinfo)"
make commoninstall bininstall

ldconfig

cd ~
rm -rf ~/*

apt-get purge --auto-remove -qy \
    ${BUILD_DEPS} \
    ${EXTRA_BUILD_DEPS} \
    ${EXTRA}

apt-get install -qfy --no-install-recommends \
    ${RUN_DEPS}

apt-get clean