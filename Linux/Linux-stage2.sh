#!/bin/bash

set -x
export DEBIAN_FRONTEND=noninteractive

python3 -m ensurepip --upgrade

python3 -m pip install -U pip=="${PIP_VER}"
python3 -m pip install -U setuptools=="${SETUPTOOLS_VERSION}"
python3 -m pip install -U wheel=="${WHEEL_VERSION}"

python3 -m pip install pyinstaller=="${PYINSTALLER_VERSION}"
