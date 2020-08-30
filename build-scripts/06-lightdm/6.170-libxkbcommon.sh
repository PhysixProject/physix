#!/bin/bash
source ../include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2

prep() {
	return 0
}

config() {
	./configure $XORG_CONFIG --docdir=/usr/share/doc/libxkbcommon-0.8.4
	chroot_check $? 'configure'
}

build() {
	make
	chroot_check $? 'make'
}

build_install() {
	make install
	chroot_check $? 'make install'
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


