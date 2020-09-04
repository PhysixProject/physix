#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /mnt/physix/opt/admin/physix/include.sh || exit 1
source ~/.bashrc


prep() {
	exit 0
}

config() {
	./configure --prefix=/tools
	check $? "bison Configre"
}

build() {
	make
	check $? "bison make"

	make check
	check $? "bison make chck" NOEXIT
}

build_install() {
make install
check $? "bison  make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


