#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source ../../physix/include.sh || exit 1
cd $BUILDROOT/sources/$1 || exit 1
source ~/.bashrc

make mrproper
check $? "make mrproper"

make INSTALL_HDR_PATH=dest headers_install
check $? "Linux make headers"

cp -rv dest/include/* /tools/include
check $? "cp -rv dest/include/* /tools/include"


