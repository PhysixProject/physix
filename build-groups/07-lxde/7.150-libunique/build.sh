#!/bin/bash
source ../include.sh || exit 1

prep() {
	patch -Np1 -i ../libunique-1.1.6-upstream_fixes-1.patch
}

config() {
	autoreconf -fi && ./configure --prefix=/usr  \
            --disable-dbus \
            --disable-static
	chroot_check $? "configure"
}

build() {
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
	make install
	chroot_check $? "make install"
}


[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

