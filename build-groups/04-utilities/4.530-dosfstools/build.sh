#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/               \
	            --enable-compat-symlinks \
	            --mandir=/usr/share/man  \
	            --docdir=/usr/share/doc/dosfstools-4.1
	chroot_check $? "dosfstools : configure"
}

build() {
	make -j$NPROC
	chroot_check $? "dosfstools : make"
}

build_install() {
	make install
	chroot_check $? "parted : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

