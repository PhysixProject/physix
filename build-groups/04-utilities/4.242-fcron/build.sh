#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr      \
            --sysconfdir=/etc      \
            --localstatedir=/var   \
            --without-sendmail     \
            --with-piddir=/run     \
            --with-boot-install=no
	chroot_check $? "configure"
}

build() {
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
	install -vdm754 /etc/cron.{hourly,daily,weekly,monthly}
	chroot_check $? "mkdir /etc/cron.{hourly,daily,weekly,monthly}"

	make install
	chroot_check $? "make install"

	install -v -m755 $PKG_DIR_PATH/usr.bin.runparts /usr/bin/run-parts
	chroot_check $? "Install runparts"

	install -v -m444 $PKG_DIR_PATH/var.spool.fcron.systab.orig /var/spool/fcron/systab.orig	
	chroot_check $? "Install systab.orig"

	systemctl enable fcron
	chroot_check $? "systemctl enable fcron"

	systemctl start fcron && fcrontab -z -u systab
	chroot_check $? "Start fcron"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

