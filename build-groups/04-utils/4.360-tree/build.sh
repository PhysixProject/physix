#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	return 0
}

build() {
	make
	chroot_check $? "tree : make"
}

build_install() {
	make MANDIR=/usr/share/man/man1 install &&
	chmod -v 644 /usr/share/man/man1/tree.1
	chroot_check $? "tree : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

