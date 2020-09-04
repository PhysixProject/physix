#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2

prep() {
	if [ -e ./build ] ; then rm -rf ./build; fi
	mkdir build
}

config() {
	cd build
	meson --prefix=$XORG_PREFIX -Dudev=true 
}

build() {
	cd build
	ninja
	chroot_check $? "libdrm : ninja "
}

build_install() {
	cd build
	ninja install
	chroot_check $? "libdrm : ninja install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


