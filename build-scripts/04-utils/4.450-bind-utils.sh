#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr --without-python
	chroot_check $? "bind-utils : configure"
}

build() {
	make -C lib/dns    &&
        make -C lib/isc    &&
        make -C lib/bind9  &&
        make -C lib/isccfg &&
        make -C lib/irs    &&
        make -C bin/dig
	chroot_check $? "bind-utils : make"
}

build_install() {
	make -C bin/dig install
	chroot_check $? "bind-utils : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

