#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2

prep() {
	mkdir  libtiff-build
	chroot_check $? "mkdir"
}

config() {
	cd libtiff-build
	cmake -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/libtiff-4.0.10 -DCMAKE_INSTALL_PREFIX=/usr -G Ninja ..
	chroot_check $? 'cmake'
}

build() {
	cd libtiff-build
	ninja
	chroot_check $? 'ninja'
}

build_install() {
	cd libtiff-build
	ninja install
	chroot_check $? 'make install'
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


