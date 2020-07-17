#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	su physix -c 'mkdir ./build'
}

config() {
	cd ./build
	./configure --prefix=/usr
	chroot_check $? "configure"
}

build() {
	cd build
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
	cd build
	make install
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


