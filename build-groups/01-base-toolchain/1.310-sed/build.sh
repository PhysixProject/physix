#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source ../include.sh || exit 1
source ~/.bashrc

prep() {
	exit 0
}

config() {
	./configure --prefix=/tools
	check $? "Sed: Configure"
}

build() {
	make -j8
	check $? "Sed: make"

	make check
	# not necessary and often returns non zero
	check $? "Sed make check" NOEXIT
}

build_install() {
	make install
	check $? "Sed: make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


