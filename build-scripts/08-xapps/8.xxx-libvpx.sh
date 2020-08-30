#!/bin/bash
source ../include.sh || exit 1

prep() {
	sed -i 's/cp -p/cp/' build/make/Makefile
	chroot_check $? "sed fix"

	mkdir build
	chroot_check $? "mkdir build"
}

config() {
	cd build
	../configure --prefix=/usr \
              --enable-shared \
              --disable-static
	chroot_check $? "configure"
}


build() {
	cd build
	make
	chroot_check $? "make"
}

build_install() {
	cd build
	make install &&
	install -v -m644 doc/Vorbis* /usr/share/doc/libvorbis-1.3.6
	chroot_check $? "make install"
}


[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?
