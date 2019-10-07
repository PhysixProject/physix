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

sed -i s/mawk// configure
check $? "ncurses sed -i s/mawk// configure"

./configure --prefix=/tools \
            --with-shared   \
            --without-debug \
            --without-ada   \
            --enable-widec  \
            --enable-overwrite

check $? "ncurses Configre"

make -j8 
check $? "ncurses make"

make install
check $? "ncurses  make install"

ln -s libncursesw.so /tools/lib/libncurses.so
check $? "ncurses ln -s libncursesw.so /tools/lib/libncurses.so"

rm -rf /mnt/lfs/sources/$SRCD
check $?i "ncurses: rm -rf /mnt/lfs/sources/ncurses-6.1"

