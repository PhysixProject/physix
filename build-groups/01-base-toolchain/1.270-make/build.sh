#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source ../include.sh || exit 1
source ~/.bashrc

prep() {
	sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c
}

config() {
	./configure --prefix=/tools --without-guile
	check $? "make: Configure"
}

build() {
	make
	check $? "make: make"

	make check
	check $? "make make check" NOEXIT
}

build_install() {
	make install
	check $? "make make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


