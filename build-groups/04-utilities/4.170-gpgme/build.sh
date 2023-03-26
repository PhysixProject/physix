#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr --disable-gpg-test
	chroot_check $? "gpgme : configure"
}

build() {
	make -j$NPROC
	chroot_check $? "gpgme : make"
}

build_install() {
	make install
	chroot_check $? "gpgme : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

