#!/bin/bash

verlessthen() {
    [[ ${PYTHON_VERSION} = $(printf "%s\\n%s" "${1}" "${2}" | sort -V | head -n1) ]]
}

shopt -s nocasepatch
set -x
export DEBIAN_FRONTEND=noninteractive

Xvfb :0 -screen 0 1920x1080x16 &

# +------------+-------------------------+
# | Visual C++ | CPython                 |
# +------------+-------------------------+
# | 14.X (201x)| 3.5, 3.6, 3.7, 3.8      |
# | 10.0 (2010)| 3.3, 3.4                |
# | 9.0  (2008)| 2.6, 2.7, 3.0, 3.1, 3.2 |
# +------------+-------------------------+

# +-------------+----------------------------------------------------------------------------+------------------+-----------------------------------------------------------------------------------------------+
# | CPython     | URL                                                                        | Arch list        | Part list                                                                                     |
# +-------------+----------------------------------------------------------------------------+------------------+-----------------------------------------------------------------------------------------------+
# | 3.0 - 3.4.4 | https://www.python.org/ftp/python/${PY_VER}/python-${PY_VER}${PY_ARCH}.msi | "", "amd64"      |                                                                                               |
# | 3.5.0 -     | https://www.python.org/ftp/python/${PY_VER}/${PY_ARCH}/${PY_PARTS}.msi     | "win32", "amd64" | "core", "dev", "doc", "exe", launcher", lib", "path", "pip", "tcltk", "test", "tools", "urct" |
# +-------------+----------------------------------------------------------------------------+------------------+-----------------------------------------------------------------------------------------------+

if verlessthen "${PYTHON_VERSION}" "3.3.0"
then
    winetricks -q winxp vcrun2008
elif verlessthen "${PYTHON_VERSION}" "3.5.0"
then
    winetricks -q winxp vcrun2010
elif verlessthen "${PYTHON_VERSION}" "3.9.0"
then
    winetricks -q win7 vcrun2019
else
    winetricks -q win10 vcrun2019
fi

if verlessthen "${PYTHON_VERSION}" "3.5.0"
then
    if [[ ${WINEARCH} = win32 ]]
    then
        wget -nv "https://www.python.org/ftp/python/${PYTHON_VERSION}/python-${PYTHON_VERSION}.msi"
    else
        wget -nv "https://www.python.org/ftp/python/${PYTHON_VERSION}/python-${PYTHON_VERSION}.amd64.msi"
    fi
    wine msiexec /i "python-${PYTHON_VERSION}.msi" /q TARGETDIR=C:\\Python
    rm "python-${PYTHON_VERSION}.msi"
else
    for filename in core dev exe lib path pip tcltk tools
    do
        if [[ ${WINEARCH} = win32 ]]
        then
            wget -nv "https://www.python.org/ftp/python/${PYTHON_VERSION}/win32/${filename}.msi"
        else
            wget -nv "https://www.python.org/ftp/python/${PYTHON_VERSION}/amd64/${filename}.msi"
        fi
        wine msiexec /i "${filename}.msi" /q TARGETDIR=C:\\Python
        rm "${filename}.msi"
    done
fi

cd /wine/drive_c/Python || exit 1
echo 'wine '\''C:\Python\python.exe'\'' "$@"' > /usr/bin/wpython
echo 'wine '\''C:\Python\Scripts\easy_install.exe'\'' "$@"' > /usr/bin/weasy_install
echo 'wine '\''C:\Python\Scripts\pip.exe'\'' "$@"' > /usr/bin/wpip
echo 'wine '\''C:\Python\Scripts\pyinstaller.exe'\'' "$@"' > /usr/bin/wpyinstaller
echo 'wine '\''C:\Python\Scripts\pyupdater.exe'\'' "$@"' > /usr/bin/wpyupdater
echo 'assoc .py=PythonScript' | wine cmd
echo 'ftype PythonScript=c:\Python\python.exe "%1" %*' | wine cmd
chmod +x /usr/bin/wpython /usr/bin/weasy_install /usr/bin/wpip /usr/bin/wpyinstaller /usr/bin/wpyupdater

wpython -m pip install -U pip=="${PIP_VER}"
wpip install -U setuptools=="${SETUPTOOLS_VERSION}"
wpip install -U wheel=="${WHEEL_VERSION}" 
wpip install pyinstaller=="${PYINSTALLER_VERSION}"