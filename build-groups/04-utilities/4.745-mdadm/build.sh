#!/bin/bash
source ../include.sh || exit 1

prep() {
	sed 's@-Werror@@' -i Makefile
	chroot_check $? "Sed Makefile"
}

config() {
	return 0
}

build() {
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
	make install
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

