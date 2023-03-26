#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	sh autogen.sh &&
	./configure --prefix=/usr --disable-static
	chroot_check $? "libuv : configure"
}

build() {
	make -j$NPROC
	chroot_check $? "libuv : make"
}

build_install() {
	make install
	chroot_check $? "libuv : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

