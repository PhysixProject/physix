#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /mnt/physix/opt/physix/include.sh || exit 1
cd $BR_SOURCE_DIR/$1 || exit 1
source ~/.bashrc

make mrproper
check $? "make mrproper"

make headers
check $? "Linux make headers"

cp -rv usr/include/* /tools/include
check $? "cp -rv dest/include/* /tools/include"


