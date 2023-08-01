#!/bin/bash
source ../include.sh || exit 1

prep() {
	sed -i '/utsname.h/a#include <sys/sysmacros.h>' libparted/arch/linux.c
	chroot_check $? "sed libparted/arch/linux.c"
}

config() {
	./configure --prefix=/usr --disable-static
	chroot_check $? "configure"
}

build() {
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
	make -C doc html                                       &&
	makeinfo --html      -o doc/html       doc/parted.texi &&
	makeinfo --plaintext -o doc/parted.txt doc/parted.texi
	chroot_check $? "parted : make install docs"

	make install &&
	install -v -m755 -d /usr/share/doc/parted-3.2/html &&
	install -v -m644    doc/html/* \
	                    /usr/share/doc/parted-3.2/html &&
	install -v -m644    doc/{FAT,API,parted.{txt,html}} \
        	            /usr/share/doc/parted-3.2
	chroot_check $? "parted : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

