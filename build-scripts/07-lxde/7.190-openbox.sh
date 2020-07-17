#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	2to3-3.7 -w data/autostart/openbox-xdg-autostart &&
	sed 's/python/python3/' -i data/autostart/openbox-xdg-autostart
}

config() {
	./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --docdir=/usr/share/doc/openbox-3.6.1
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

