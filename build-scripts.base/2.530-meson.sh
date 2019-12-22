#!/bin/bash 
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd /sources/$1 || exit 1           

python3 setup.py build
chroot_check $? "meson python3 setup.py build"

python3 setup.py install --root=dest
chroot_check $? "meson python3 setup.py install "

cp -rv dest/* /

