#!/bin/bash
source ../include.sh || exit 1

prep() {
        return 0
}

config() {
	./configure --prefix=/usr    \
            --disable-static \
            --with-history   \
            --with-python=/usr/bin/python3
	chroot_check $? "libxml2 : configure"
}

build() {
	make
	chroot_check $? "libxml2 : make"
}

build_install() {
	make install
	chroot_check $? "libxml2 : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?



