#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	make autotools
	chroot_check $? "make autotools"
}

config() {
	./configure --prefix=/usr/local/bin/ltp
	chroot_check $? "configure"
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


