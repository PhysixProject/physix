#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr \
            --docdir=/usr/share/doc/gnutls-3.6.9 \
            --disable-guile \
            --with-default-trust-store-pkcs11="pkcs11:"
	chroot_check $? "gnutls : configure"
}


build() {
	make
	chroot_check $? "gnutls : make"
}

build_install() {
	make install
	chroot_check $? "gnutls : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

