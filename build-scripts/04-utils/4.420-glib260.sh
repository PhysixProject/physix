#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	[ ! -e ./build ] || rm -r ./build
	patch -Np1 -i ../glib-2.60.6-skip_warnings-1.patch
}

config() {
	mkdir build &&
        cd build &&
        meson --prefix=/usr  \
         -Dman=false         \
         -Dselinux=disabled  \
         ..
	chroot_check $? "glib-2.60 : config"
}

build() {
	cd build && ninja
	chroot_check $? "build"

}

build_install() {
	cd build && 
	ninja install &&
	mkdir -p /usr/share/doc/glib-2.60.6 &&
	cp -r ../docs/reference/{NEWS,gio,glib,gobject} /usr/share/doc/glib-2.60.6
	chroot_check $? "glibc 2.60 : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


