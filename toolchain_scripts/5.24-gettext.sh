#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source $SCRIPTPATH/../include.sh
source ~/.bashrc

cd $BUILDROOT/sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

unpack $PKG
cd $BUILDROOT/sources/$SRCD

./configure --disable-shared
check $? "gettext: Configure"

make 
check $? "gettext make"

cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /tools/bin

rm -rf $BUILDROOT/sources/$SRCD
