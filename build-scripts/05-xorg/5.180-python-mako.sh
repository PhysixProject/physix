#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2

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
	python3 setup.py install --optimize=1
	chroot_check $? "python3 setup.py install --optimize=1"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

