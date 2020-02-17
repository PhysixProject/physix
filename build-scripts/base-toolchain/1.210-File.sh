#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /mnt/physix/physix/include.sh || exit 1
cd $BR_SOURCE_DIR/$1 || exit 1
source ~/.bashrc

./configure --prefix=/tools
check $? "File configure"

make
check $? "File make"

make check
check $? "File make check" NOEXIT

make install
check $? "File make install"

