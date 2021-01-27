#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source ../include.sh || exit 1

prep() {
	sed -i 's/GROUP="render", //' rules.d/50-udev-default.rules.in
	mkdir -p build
}

config() {

	cd build

	meson --prefix=/usr             \
		--sysconfdir=/etc           \
		--localstatedir=/var        \
		-Dblkid=true                \
		-Dbuildtype=release         \
		-Ddefault-dnssec=no         \
		-Dfirstboot=false           \
		-Dinstall-tests=false       \
		-Dldconfig=false            \
		-Dman=auto                  \
		-Drootprefix=               \
		-Drootlibdir=/lib           \
		-Dsplit-usr=true            \
		-Dsysusers=false            \
		-Drpmmacrosdir=no           \
		-Db_lto=false               \
		-Dhomed=false               \
		-Duserdb=false              \
		-Ddocdir=/usr/share/doc/systemd-246 \
		..
	chroot_check $? "systemd : configure"
}

build() {
	cd ./build  && ninja
	chroot_check $? "systemd : ninja"
}

build_install() {

	cd build

    systemctl daemon-reload
    chroot_check $? "Daemon Reload"

    sync
    sync

	ninja install
	chroot_check $? "ninja install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

