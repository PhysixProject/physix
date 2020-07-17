#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2

prep() {
	sed -i "s/pthread-stubs//" configure
	chroot_check $? "libxcb : sed -i "s/pthread-stubs//" configure"
}

config() {
	./configure $XORG_CONFIG      \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-1.13.1
}

build() {
	make -j$NPROC
	chroot_check $? "libxcb :config / make"
}

build_install() {
	make install
	chroot_check $? "libxcb : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


