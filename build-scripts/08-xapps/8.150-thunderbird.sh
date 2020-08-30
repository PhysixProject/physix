#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	cp /opt/admin/physix/build-scripts/08-xapps/configs/thunderbird/mozconfig .
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
