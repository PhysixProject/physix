#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2

prep() {
	return 0	
}

config() {
	./configure $XORG_CONFIG            \
            --enable-glamor         \
            --enable-suid-wrapper   \
            --with-xkb-output=/var/lib/xkb
	chroot_check $? "./configure $XORG_CONFIG"
}

build() {
	make 
	chroot_check $? "make "
}

build_install() {
	make install &&
	mkdir -pv /etc/X11/xorg.conf.d
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


