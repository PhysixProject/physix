#!/bin/bash
source ../include.sh || exit 1

prep() {
	return
}

config() {
	meson build
	chroot_check $? "Pacman: Config"
}

build() {
	ninja -C build
	chroot_check $? "Pacman: Build"
}

build_install() {
	ninja -C build install
	chroot_check $? "Pacman: Installed"
}

[ $1 == 'prep' ]   && prep   && exit 0
[ $1 == 'config' ] && config && exit 0
[ $1 == 'build' ]  && build  && exit 0
[ $1 == 'build_install' ] && build_install && exit 0

