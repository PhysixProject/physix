#!/bin/bash -x
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2

prep() {
	mkdir ./build
}

config() {
	cd build
	meson --prefix=$XORG_PREFIX ..
	chroot_check $? "xorgproto : config"
}

build() {
	cd build
	ninja
}

build_install() {
	cd build &&
	ninja install &&
	install -vdm 755 $XORG_PREFIX/share/doc/xorgproto-2019.1 &&
	install -vm 644 ../[^m]*.txt ../PM_spec $XORG_PREFIX/share/doc/xorgproto-2019.1
	chroot_check $? "xorgproto : ninja install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


