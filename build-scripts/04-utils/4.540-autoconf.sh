#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	patch -Np1 -i ../autoconf-2.13-consolidated_fixes-1.patch
	chroot_check $? "patch"

	mv -v autoconf.texi autoconf213.texi  && rm -v autoconf.info
	chroot_check $? "adjust key files"
}

config() {
	./configure --prefix=/usr --program-suffix=2.13
	chroot_check $? "configure"
}

build() {
	make
	chroot_check $? "make"
}

build_install() {
	make install                                      &&
	install -v -m644 autoconf213.info /usr/share/info &&
	install-info --info-dir=/usr/share/info autoconf213.info
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

