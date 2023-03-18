#!/bin/bash
source ../include.sh || exit 1

prep() {
	sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake 
}

config() {
	./bootstrap --prefix=/usr \
            --system-libs         \
            --mandir=/share/man   \
            --no-system-jsoncpp   \
            --no-system-librhash  \
            --docdir=/share/doc/cmake-3.15.2
	chroot_check $? "cmake: bootstrap"
}

build() {
	make -j$NPROC
	chroot_check $? "cmake: make"
}

build_install() {
	make install
	chroot_check $? "cmake: make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

