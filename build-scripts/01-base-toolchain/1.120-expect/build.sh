#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /mnt/physix/opt/admin/physix/include.sh || exit 1
source ~/.bashrc

prep() {
	cp -v configure{,.orig}
	check $? "Expect: cp -v configure{,.orig}"

	sed 's:/usr/local/bin:/bin:' configure.orig > configure
	check $? "Expect: sed 's:/usr/local/bin:/bin:' configure.orig > configure"
}


config() {
	./configure --prefix=/tools       \
            --with-tcl=/tools/lib \
            --with-tclinclude=/tools/include
	check $? "Expect: Configure"
}


build() {
	make -j8
	check $? "Expect: make"
}


build_install() {
	make install
	check $? "Expect: make install"

	make test
	check $? "Expect Test" NOEXIT

	make SCRIPTS="" install
	check $? "Expect: make SCRIPTS="" install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


