#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source ../include.sh || exit 1
source ~/.bashrc

prep() {
	exit 0
}

config() {
	./configure --prefix=/tools --without-bash-malloc
	check $? "bash Configre"
}

build() {
	make -j8
	check $? "bash make"

	#make tests
	#check $? "bash make tests" NOEXIT
}

build_install() {
	make install
	check $? "bash  make install"

	ln -sfv bash /tools/bin/sh
	check $? "bash: ln -sv bash /tools/bin/sh"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

