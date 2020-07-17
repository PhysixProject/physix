#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2

prep() {
	sed -i -e "/D_XOPEN/s/5/6/" configure
	chroot_check $? "sed configure"
}

config() {
	./configure $XORG_CONFIG
	chroot_check $? "./configure $XORG_CONFIG"
}

build() {
	make 
	chroot_check $? "make "
}

build_install() {
	make install
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


