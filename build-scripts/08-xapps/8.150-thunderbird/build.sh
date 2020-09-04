#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	cp $PKG_DIR_PATH/mozconfig .
	chroot_check $? 'Write config'
}

build() {
	source /etc/profile.d/rustc.sh && ./mach build
	chroot_check $? 'mach build'
}

build_install() {
	./mach install
	chroot_check $? 'mach install'
}


[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?
