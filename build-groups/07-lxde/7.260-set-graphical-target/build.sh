#!/bin/bash
source include.sh || exit 1

prep() {
	return 0
}

config() {
	return 0
}

build() {
	return 0
}


build_install() {
	if [ -L /etc/systemd/system/default.target ] ; then
		rm /etc/systemd/system/default.target
		chroot_check $? "rm link to default.target"
	fi

	ln -s  /lib/systemd/system/graphical.target /etc/systemd/system/default.target
	chroot_check $? "link default.target"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

