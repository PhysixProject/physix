#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	patch -Np1 -i ../liboauth-1.0.3-openssl-1.1.0-3.patch
	chroot_check $? "liboauth : patch"
}

config() {
	./configure --prefix=/usr --disable-static
	chroot_check $? "liboauth : cofnigure"
}

build() {
	make
	chroot_check $? "liboauth : make"
}

build_install() {
	make install
	chroot_check $? "liboauth : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

