#!/bin/bash
source ../include.sh || exit 1

prep(){
	return 0
}

config() {
	./configure --prefix=/usr  \
              --enable-shared      \
              --with-system-expat  \
              --with-system-ffi    \
              --with-ensurepip=yes \
              --enable-unicode=ucs4
	chroot_check $? "configure"
}

build() {
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
	make install &&
	chmod -v 755 /usr/lib/libpython2.7.so.1.0
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

