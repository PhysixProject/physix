#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure                   \
              --prefix=/usr                 \
              --libexecdir=/usr/lib/lightdm \
              --sbindir=/usr/bin            \
              --sysconfdir=/etc             \
              --with-libxklavier            \
              --enable-kill-on-sigterm      \
              --disable-libido              \
              --disable-libindicator        \
              --disable-static              \
              --docdir=/usr/share/doc/lightdm-gtk-greeter-2.0.6
	chroot_check $? "configure lightdm-greeter"
}

build() {
	make -j$NPROC
	chroot_check $? "make lightdm-greeter"
}

build_install() {
	make install
	chroot_check $? "make install lightdm-greeter"

	cp -v /opt/admin/physix/build-scripts/06-lightdm/configs/lightdm/lightdm.service /lib/systemd/system/
	chroot_check $? "setup /lib/systemd/system/"

	systemctl enable lightdm
	chroot_check $? "enable lightdm"
}


[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?
