#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /mnt/physix/opt/admin/physix/include.sh || exit 1
source ~/.bashrc

prep(){
	mkdir -v build
	cd       build
}

config() {
	cd build
	../configure --prefix=/tools --with-sysroot=$BUILDROOT --with-lib-path=/tools/lib --target=$BUILDROOT_TGT --disable-nls --disable-werror
	check $? "Binutils Configure"
}

build() {
	cd build
	make -j$NPROC
	check $? "Binutils make"
}

build_install() {
	cd build
	case $(uname -m) in
	  x86_64) mkdir -v /tools/lib && ln -sfv lib /tools/lib64 ;;
	esac

	make install
	check $? "Binutils make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

