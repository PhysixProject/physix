#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source ../include.sh || exit 1
source ~/.bashrc


prep() {
	sed -i s/mawk// configure
	check $? "ncurses sed -i s/mawk// configure"
}

config() {
	./configure --prefix=/tools \
            --with-shared   \
            --without-debug \
            --without-ada   \
            --enable-widec  \
            --enable-overwrite
	check $? "ncurses Configre"
}

build() {
	make -j8
	check $? "ncurses make"
}

build_install() {
	make install
	check $? "ncurses  make install"

	ln -sf libncursesw.so /tools/lib/libncurses.so
	check $? "ncurses ln -sf libncursesw.so /tools/lib/libncurses.so"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

