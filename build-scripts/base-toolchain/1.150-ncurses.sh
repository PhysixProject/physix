#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /mnt/physix/physix/include.sh || exit 1
cd $BR_SOURCE_DIR/$1 || exit 1
source ~/.bashrc

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

