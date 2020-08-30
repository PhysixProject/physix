#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libunistring-0.9.10
	chroot_check $? "libunistring : configure"
}

build() {
	make
	chroot_check $? "libunistring : make"
}

build_install() {
	make install
	chroot_check $? "libunistring : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

