#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr             \
            --infodir=/usr/share/info         \
            --mandir=/usr/share/man           \
            --with-socket-dir=/run/screen     \
            --with-pty-group=5                \
            --with-sys-screenrc=/etc/screenrc
	chroot_check $? "screen : configure"
}

build() {
	sed -i -e "s%/usr/local/etc/screenrc%/etc/screenrc%" {etc,doc}/*
	make -j$NPROC
	chroot_check $? "screen : make"
}

build_install() {
	make install &&
	install -m 644 etc/etcscreenrc /etc/screenrc
	chroot_check $? "screen : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

