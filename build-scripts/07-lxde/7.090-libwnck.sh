#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr \
            --disable-static \
            --program-suffix=-1
	chroot_check $? "configure"
}

build() {
	make GETTEXT_PACKAGE=libwnck-1
	chroot_check $? "make"
}

build_install() {
	make GETTEXT_PACKAGE=libwnck-1 install
	chroot_check $? "make install"
}


[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

