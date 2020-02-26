#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /mnt/physix/opt/physix/include.sh || exit 1
cd $BR_SOURCE_DIR/$1 || exit 1
source ~/.bashrc

cd unix
./configure --prefix=/tools
check $? "TCL cofigure"

make -j8
check $? "TCL make"

#TZ=UTC make test

make install
check $? "TCL make isntall"

chmod -v u+w /tools/lib/libtcl8.6.so
check $? "TCL chmod -v u+w /tools/lib/libtcl8.6.so"

make install-private-headers
check $? "TCL make install-private-headers"

ln -sfv tclsh8.6 /tools/bin/tclsh
check $? "TCL ln -sfv tclsh8.6 /tools/bin/tclsh"


