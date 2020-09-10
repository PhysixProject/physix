#!/bin/bash
source ../include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2

prep() {
	gzip -cd ../libpng-1.6.37-apng.patch.gz | patch -p1
	chroot_check $? "unzip patch"
}

config() {
	./configure --prefix=/usr --disable-static
	chroot_check $? "configure"
}

build() {
	make -j$NPROC
	chroot_check $? "make"

	make check
	chroot_check $? "make check"
}

build_install() {
	make install &&
	mkdir -pv /usr/share/doc/libpng-1.6.37 &&
	cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.37
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


