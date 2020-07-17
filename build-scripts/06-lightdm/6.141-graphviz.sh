#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	autoreconf
	chroot_check $? 'autoreconf'
}

config() {
	./configure --prefix=/usr
	chroot_check $? 'configure'
}

build() {
	make -j$NPROC
	chroot_check $? 'make'
}

build_install() {
	make install
	chroot_check $? 'make install'

	ln -v -sf /usr/share/graphviz/doc \
        	 /usr/share/doc/graphviz-2.40.1
 }
[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

