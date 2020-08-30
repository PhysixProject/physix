#!/bin/bash
source ../include.sh || exit 1

prep() {
	mkdir build
	chroot_check $? "mkdir build"
}

config() {
	cd build
	meson --prefix=/usr \
              -Dadmin_group=adm   \
              -Dsystemd=true ..
	chroot_check $? "meson configure "
}

build() {
	#sed -i 's/'-nonet'//' docs/man/Makefile.in  &&
	#sed -i 's/'-nonet'//' docs/man/Makefile     &&
	#sed -i 's/'-nonet'//' docs/man/Makefile.am
	#chroot_check $? "sed rm nonet switch"
	cd build
	ninja
	chroot_check $? "ninja"
}

build_install() {
	cd build
	ninja install
	chroot_check $? "ninja install"

	cp /opt/admin/physix/build-scripts/05-xorg/configs/polkit/40-adm.rules  /etc/polkit-1/rules.d/
	chroot_check $? "Write /etc/polkit-1/rules.d/40-adm.rules"

	systemctl enable accounts-daemon
	chroot_check $? "Enable accounts-daemon"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


