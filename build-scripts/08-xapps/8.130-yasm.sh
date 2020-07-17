#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	#This sed prevents it compiling 2 programs (vsyasm and ytasm) 
	#that are only of use on Microsoft Windows.
	sed -i 's#) ytasm.*#)#' Makefile.in
	chroot_check $? "Sed fix"
}

config() {
	./configure --prefix=/usr
	chroot_check $? "configure"
}

build() {
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
	make install
	chroot_check $? "make install"
}


[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?
