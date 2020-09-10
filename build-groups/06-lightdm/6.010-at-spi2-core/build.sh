#!/bin/bash
source ../include.sh || exit 1

prep() {
	mkdir ./build
	chroot_check $? "create build dir"
}

config() {
	cd ./build
	meson --prefix=/usr     \
      	--sysconfdir=/etc \
      	-Dsystemd_user_dir=no ..
	chroot_check $? "meson config"
}

build() {
	cd ./build
	ninja
	chroot_check $? "ninja build"
}

build_install() {
	cd ./build
	ninja install
	chroot_check $? "ninja install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


