#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	cd nspr                                                     &&
	sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in &&
	sed -i 's#$(LIBRARY) ##'            config/rules.mk 
	chroot_check $? "prep"
}

config() {
	./configure --prefix=/usr \
            --with-mozilla \
            --with-pthreads \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit)
	chroot_check $? "nspr : configure"
}

build() {
	make
	chroot_check $? "nspr : make"
}

build_install() {
	make install
	chroot_check $? "nspr : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

