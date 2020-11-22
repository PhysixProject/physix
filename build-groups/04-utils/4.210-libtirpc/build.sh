#!/bin/bash
source ../include.sh || exit 1

prep() { 
	return 0 
}

config() {
	./configure --prefix=/usr   \
            --sysconfdir=/etc       \
            --disable-static        \
            --disable-gssapi
	chroot_check $? "libtirpc : configure"
}

build() {
	make -j$NPROC
	chroot_check $? "libtirpc : make"
}


build_install() {
	make install &&
	mv -v /usr/lib/libtirpc.so.* /lib &&
	ln -sfv ../../lib/libtirpc.so.3.0.0 /usr/lib/libtirpc.so
	chroot_check $? "libtirpc : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


