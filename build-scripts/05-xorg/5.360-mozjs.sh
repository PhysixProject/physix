#!/bin/bash
source /opt/admin/physix/include.sh || exit 1


prep() {
	mkdir mozjs-build
}

config() {
	cd mozjs-build
	../js/src/configure --prefix=/usr \
                    --with-intl-api     \
                    --with-system-zlib  \
                    --with-system-icu   \
                    --disable-jemalloc  \
                    --enable-readline
	chroot_check $? "configure"
}

build() {
	cd mozjs-build
	make
	chroot_check $? "make"
}

build_install() {
	cd mozjs-build
	make install 
	chroot_check $? "make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


