#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
        return 0
}

config() {
        return 0
}

build() {
        make -j$NPROC
        chroot_check $? "make"

        #sed -i '/find/s:/usr/bin/::' tests/Makefile
        #make -k test
}

build_install() {
	make install
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

