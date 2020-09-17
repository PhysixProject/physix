#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source ../include.sh || exit 1
source ~/.bashrc


prep() {
	sed -i '/def add_multiarch_paths/a \        return' setup.py
}

config() {
	./configure --prefix=/tools --without-ensurepip
	check $? "perl: Configure"
}

build() {
	make -j8
	check $? "python: make"
}

build_install() {
	make install
	check $? "python make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


