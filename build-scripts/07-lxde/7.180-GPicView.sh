#!/bin/bash
source /opt/admin/physix/include.sh || exit 1


prep() {
	return 0
}

config() {
	./configure --prefix=/usr
	chroot_check $? "configure"
}

build() {
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
	make install &&
	sed -i 's/Utility;//' /usr/share/applications/gpicview.desktop
	chroot_check $? "make install"
}



[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

