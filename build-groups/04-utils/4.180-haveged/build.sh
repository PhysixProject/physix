#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr
	chroot_check $? "haveged : configure"
}

build(){
	make -j$NPROC
	chroot_check $? "haveged : make"
}

build_install() {
	make install &&
	mkdir -pv    /usr/share/doc/haveged-1.9.2 &&
	cp -v README /usr/share/doc/haveged-1.9.2
	chroot_check $? "haveged : make install"
}

#init script for boot
#make install-haveged

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

