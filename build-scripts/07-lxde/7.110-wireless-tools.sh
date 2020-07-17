#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	patch -Np1 -i ../wireless_tools-29-fix_iwlist_scanning-1.patch
	chroot_check $? "patch"
}

config() {
	return 0
}

build() {
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
	make PREFIX=/usr INSTALL_MAN=/usr/share/man install
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

