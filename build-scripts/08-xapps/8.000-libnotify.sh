#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	mkdir build
	chroot_check $? "mkdir build"
}

config() {
	cd build
	meson --prefix=/usr -Dgtk_doc=false ..
	chroot_check $? "configure"
}

build() {
	cd build
	ninja
	chroot_check $? "ninja"
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
