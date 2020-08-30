#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr
	chroot_check $? "npth: make install"
}

build() {
	make
	chroot_check $? "npth: make"
}

build_install() {
	make install
	chroot_check $? "npth: make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

