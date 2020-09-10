#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr \
              --with-crypto_backend=openssl
	chroot_check $? "cryptsetup: configure"
}

build() {
	make
	chroot_check $? "cryptsetup: make"
}

build_install() {
	make install
	chroot_check $? "cryptsetup: make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

