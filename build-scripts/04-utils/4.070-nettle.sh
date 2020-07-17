#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
        return 0
}

config() {
        ./configure --prefix=/usr --disable-static
        chroot_check $? "nettle : configure"
}

build() {
        make
        chroot_check $? "nettle : make"
}

build_install() {
        make install &&
        chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
        install -v -m755 -d /usr/share/doc/nettle-3.5.1 &&
        install -v -m644 nettle.html /usr/share/doc/nettle-3.5.1
        chroot_check $? "nettle : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

