#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /mnt/physix/opt/admin/physix/include.sh || exit 1
source ~/.bashrc

prep() {
	mkdir -v build
}

config() {
	cd build
	../libstdc++-v3/configure       \
    --host=$BUILDROOT_TGT           \
    --prefix=/tools                 \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-threads     \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$BUILDROOT_TGT/include/c++/9.2.0

	check $? "stdc++: configure"
}

build() {
	cd build
	make -j8
	check $? "stdc++: make"
}

build_install() {
	export BUILDROOT_TGT=$(uname -m)-lfs-linux-gnu
	PATH=$PATH:/tools/bin
	cd build
	make install
	check $? "stdc++: make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

