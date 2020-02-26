#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /mnt/physix/opt/physix/include.sh || exit 1
cd $BR_SOURCE_DIR/$1 || exit 1
source ~/.bashrc


./configure --prefix=/tools
check $? "xz: Configure"

make -j8
check $? "xz: make"

make check
# Not necessary
check $? "Tar: make check" NOEXIT

make install
check $? "xz: make install"


