#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source ../include.sh || exit 1
source ~/.bashrc

prep() {
	make mrproper
	check $? "make mrproper"
}

config() { 
	exit 0
}

build() {
	make headers
	check $? "Linux make headers"
}

build_install() {
	cp -rv usr/include/* /tools/include
	check $? "cp -rv dest/include/* /tools/include"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

