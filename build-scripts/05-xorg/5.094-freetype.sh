#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2

prep() {
	sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg
	chroot_check $? "sed modules.cfg"
	sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" -i include/freetype/config/ftoption.h
	chroot_check $? "sed ftoption.h"
}

config() {
	./configure --prefix=/usr --enable-freetype-config --disable-static
	chroot_check $? "configure"
}

build() {
	make
	chroot_check $? 'make'
}

build_install() {
	make install
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?



