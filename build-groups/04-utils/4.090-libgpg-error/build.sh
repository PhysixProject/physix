#!/bin/bash
source ../include.sh || exit 1

prep() {
	sed -i 's/namespace/pkg_&/' src/Makefile.{am,in} src/mkstrtable.awk
	chroot_check $? "prep"
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
	make install &&
	install -v -m644 -D README /usr/share/doc/libgpg-error-1.36/README
	chroot_check $? "libgpg-error : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

