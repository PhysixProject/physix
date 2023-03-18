#!/bin/bash
source ../include.sh || exit 1

prep() { 
	return 0 
}

config() {
	./configure --prefix=/usr --disable-static \
        	    --with-securedir=/lib/security \
	            --with-python-binary=python3
	chroot_check $? "libpwquality : configure"
}

build() {
	make -j$NPROC
	chroot_check $? "libpwquality : make"
}

build_install() {
	make install
	chroot_check $? "libpwquality : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

