#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source ../include.sh || exit 1
source ~/.bashrc

prep() {
	mkdir build
}

config() {
	cd build

	CC=$BUILDROOT_TGT-gcc          \
	AR=$BUILDROOT_TGT-ar           \
	RANLIB=$BUILDROOT_TGT-ranlib   \
	../configure                   \
    	--prefix=/tools            \
    	--disable-nls              \
    	--disable-werror           \
    	--with-lib-path=/tools/lib \
    	--with-sysroot
	check $? "Binutils pass 2: configure"
}

build() {
	cd build
	make -j8
	check $? "Binutils pass 2: make"
}

build_install() {
	export BUILDROOT_TGT=$(uname -m)-lfs-linux-gnu
	PATH=$PATH:/tools/bin

	cd build

	make install
	check $? "Binutils pass 2: make install"

	make -C ld clean
	check $? "make -C ld clean"

	make -C ld LIB_PATH=/usr/lib:/lib
	check $? "make -C ld LIB_PATH=/usr/lib:/lib"

	cp -v ld/ld-new /tools/bin
	check $? "Binutils pass 2: cp -v ld/ld-new /tools/bin"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

