#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr --enable-pinentry-tty
	chroot_check $? "pinentry: configure"
}

build() {
	make
	chroot_check $? "pinentry: make"
}

build_install() {
	make install
	chroot_check $? "pinentry: make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

