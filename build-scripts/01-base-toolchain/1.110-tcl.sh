#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /mnt/physix/opt/admin/physix/include.sh || exit 1
source ~/.bashrc

prep() {
	exit 0
}

config() {
	cd unix
	./configure --prefix=/tools
	check $? "TCL cofigure"
}

build() {
	cd unix
	make -j8
	check $? "TCL make"
}

build_install() {
	cd unix
	#TZ=UTC make test
	make install
	check $? "TCL make isntall"

	chmod -v u+w /tools/lib/libtcl8.6.so
	check $? "TCL chmod -v u+w /tools/lib/libtcl8.6.so"

	make install-private-headers
	check $? "TCL make install-private-headers"

	ln -sfv tclsh8.6 /tools/bin/tclsh
	check $? "TCL ln -sfv tclsh8.6 /tools/bin/tclsh"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

