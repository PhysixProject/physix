#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /mnt/lfs/physix/include.sh
source ~/.bashrc

cd /mnt/lfs/sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

unpack $PKG
cd /mnt/lfs/sources/$SRCD

./configure --disable-shared
check $? "gettext: Configure"

make 
check $? "gettext make"

cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /tools/bin

rm -rf /mnt/lfs/sources/$SRCD
