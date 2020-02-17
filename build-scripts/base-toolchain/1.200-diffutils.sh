#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /mnt/physix/physix/include.sh || exit 1
cd $BR_SOURCE_DIR/$1 || exit 1
source ~/.bashrc

./configure --prefix=/tools
check "diffutils configure"

make -j8
check $? "diffutils make"

make check
check $? "diffutils make check" NOEXIT

make install
check $? "diffutils make install"

