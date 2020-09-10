#!/bin/bash
source ../include.sh || exit 1

prep() {
	sed -i '/cmptest/d' tests/CMakeLists.txt
	chroot_check $? "sed"
	mkdir -v build
}

config() {
	cd build
	cmake -DCMAKE_INSTALL_PREFIX=/usr .. 
	chroot_check $? "cmake"
}

build() {
	cd build
	make
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


