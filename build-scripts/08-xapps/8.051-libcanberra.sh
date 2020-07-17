#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr --disable-oss
	chroot_check $? "configure"
}

build() {
	make
	chroot_check $? "make"
}

build_install() {
	make docdir=/usr/share/doc/libcanberra-0.30 install
	chroot_check $? "make install"
}


[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?
