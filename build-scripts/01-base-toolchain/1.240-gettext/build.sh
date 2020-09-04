#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /mnt/physix/opt/admin/physix/include.sh || exit 1
source ~/.bashrc

prep() {
	exit 0
}

config() {
	./configure --disable-shared
	check $? "gettext: Configure"
}

build() {
	make
	check $? "gettext make"
}

build_install() {
	cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /tools/bin
	check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


