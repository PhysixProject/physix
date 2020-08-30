#!/bin/bash
source ../include.sh || exit 1


prep() {
	cd nspr                                                     &&
	sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in &&
	sed -i 's#$(LIBRARY) ##'            config/rules.mk         &&
	chroot_check $? "nspr : sed content "
}

config() {
	cd nspr
	./configure --prefix=/usr \
        	    --with-mozilla \
	            --with-pthreads \
        	    $([ $(uname -m) = x86_64 ] && echo --enable-64bit)
	chroot_check $? "nspr : configure"
}

build() {
	cd nspr
	make
	chroot_check $? "nspr : make"
}

build_install() {
	cd nspr
	make install
	chroot_check $? "nspr : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

