#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}	

config() {
	return 0
}

build() {
	make -f unix/Makefile generic
	chroot_check $? "unzip : make generic"
}

build_install() {
	make prefix=/usr MANDIR=/usr/share/man/man1 \
	 -f unix/Makefile install
	chroot_check $? "unzip : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

