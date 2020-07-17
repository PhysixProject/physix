#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	mkdir ./build
	chroot_check $? "mkdir buiild dir"
}

config() {
	cd ./build
	cmake -DCMAKE_INSTALL_PREFIX=/usr \
      	-DCMAKE_BUILD_TYPE=RELEASE  \
      	-DENABLE_STATIC=FALSE       \
      	-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/libjpeg-turbo-2.0.2 \
      	-DCMAKE_INSTALL_DEFAULT_LIBDIR=lib ..
	chroot_check $? "cmake"
}

build() {
	cd ./build
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
	cd ./build
	make install 
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


