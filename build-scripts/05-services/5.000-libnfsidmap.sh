#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr \
              --sysconfdir=/etc   \
              --disable-static
	chroot_check $? "configure"
}

build() {
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
	make install                         &&
	mv -v /usr/lib/libnfsidmap.so.* /lib &&
	ln -sfv ../../lib/$(readlink /usr/lib/libnfsidmap.so) /usr/lib/libnfsidmap.so
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


