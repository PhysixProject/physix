#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure
	chroot_check $? "tmux : configure"
}

build() {
	make -j$NPROC
	chroot_check $? "tmux : make"
}

build_install() {
	make install
	chroot_check $? "tmux : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


