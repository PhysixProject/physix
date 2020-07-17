#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2

prep() {
	[ ! -e ./build ] || rm -r build
	mkdir build 
}

config() {
	cd build &&
	meson --prefix=$XORG_PREFIX .. 
}

build() {
	cd build
	ninja
	chroot_check $? "meson / ninja"
}

build_install() {
	cd build
	ninja install
	chroot_check $? "ninja install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

