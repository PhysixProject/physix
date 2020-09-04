#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2

prep() {
	sed -i "s/pthread-stubs//" configure && rm -f src/fcobjshash.h
	chroot_check $? "fontconfig: prep"
}

config() {
	./configure --prefix=/usr \
            --sysconfdir=/etc           \
            --localstatedir=/var        \
            --disable-docs              \
            --docdir=/usr/share/doc/fontconfig-2.13.1
}

build() {
	make
	chroot_check $? "fontconfig : make "
}

build_install() {
	make install
	chroot_check $? "fontconfig : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?



