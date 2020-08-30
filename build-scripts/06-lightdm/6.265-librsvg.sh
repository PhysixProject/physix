#!/bin/bash
source ../include.sh || exit 1


prep() {
	return 0
}

config() {
	source ~/.profile && ./configure --prefix=/usr --enable-vala --disable-static --libdir=/usr/lib64
	chroot_check $? 'configure'
}

build() {
	. /etc/profile && make -j$NPROC
	chroot_check $? "make "
}

build_install() {
	make install
	chroot_check $? 'make install'

	ldconfig
	chroot_check $? 'lodconfig'
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


