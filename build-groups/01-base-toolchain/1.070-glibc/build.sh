#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source ../include.sh || exit 1
source ~/.bashrc

prep() {
	echo $PATH
	echo $BUILDROOT_TGT

	mkdir -v build
}

config() {
	cd build
	../configure                         \
      --prefix=/tools                    \
      --host=$BUILDROOT_TGT              \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=/tools/include
	check $? "Glibc Configure"
}

build() {
	cd build
	make
	check $? "Glibc make"
}

build_install() {
	cd build
	make install
	check $? "Glibc make install"

	#sanity check
	BUILDROOT_TGT=$(uname -m)-lfs-linux-gnu
	echo 'int main(){}' > dummy.c
	/tools/bin/$BUILDROOT_TGT-gcc dummy.c
	check $? "glibc: $BUILDROOT_TGT-gcc dummy.c"

	readelf -l a.out | grep ': /tools'
	check $? "Glibc: glibc: $BUILDROOT_TGT-gcc dummy.c"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

