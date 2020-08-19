#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/physix.conf || exit 1

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
	install -m444 /opt/admin/sources.physix/sharon-mccutcheon.jpg /usr/share/lxde/wallpapers/
	chroot_check $? "install wallpaper direcory"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

