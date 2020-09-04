#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2

prep() {
	sed -i '/v0/{n;s/new:/new:kb=^?:/}' termcap && printf '\tkbs=\\177,\n' >> terminfo
}

config() {
	TERMINFO=/usr/share/terminfo \
	./configure $XORG_CONFIG --with-app-defaults=/etc/X11/app-defaults
	chroot_check $? "./configure"
}

build() {
	make
	chroot_check $? "make"
}

build_install() {
	make install    &&
	make install-ti &&
	mkdir -pv /usr/share/applications &&
	cp -v *.desktop /usr/share/applications/
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


