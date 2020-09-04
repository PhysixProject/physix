#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	perl Makefile.PL
	chroot_check $? "configure"
}

build() {
	make
	chroot_check $? "make"
}

#su physix -c 'make test'
#chroot_check $? "make test" 
build_install() {
	make install
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?
