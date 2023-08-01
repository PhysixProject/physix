#!/bin/bash
source ../include.sh || exit 1

prep(){ 
	return 0	
}

config() {
	return 0
}

build() {
	make PREFIX=/usr  \
     	SHAREDIR=/usr/share/hwdata \
     	SHARED=yes
	chroot_check $? "pciutils : make"
}

build_install() {
	make PREFIX=/usr           \
     	SHAREDIR=/usr/share/hwdata \
     	SHARED=yes                 \
     	install install-lib        &&
	chmod -v 755 /usr/lib/libpci.so
	chroot_check $? "pciutils : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


