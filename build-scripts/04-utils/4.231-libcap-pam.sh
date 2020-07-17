#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	return 0
}

config() {
	return 0
}

build() {
	make -C pam_cap
	chroot_check $? "make"
}

build_install() {
	install -v -m755 pam_cap/pam_cap.so /lib/security &&
	install -v -m644 pam_cap/capability.conf /etc/security
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

