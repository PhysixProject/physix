#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	return 0
}

build() {
	make -f unix/Makefile generic_gcc
	chroot_check $? "make"
}

build_install() {
	make prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

