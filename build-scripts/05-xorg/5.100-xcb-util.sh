#!/bin/bash
source /opt/admin/physix/include.sh
source /etc/profile.d/xorg.sh || exit 2

prep() {
	return 0
}

config() {
	./configure $XORG_CONFIG
	chroot_check $? "xcb-util : config"
}

build() {
	make
	chroot_check $? "xcb-util : make "
}

build_install() {
	make install
	chroot_check $? "xcb-util : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


