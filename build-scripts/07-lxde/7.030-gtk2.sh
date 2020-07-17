#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	sed -e 's#l \(gtk-.*\).sgml#& -o \1#' \
            -i docs/{faq,tutorial}/Makefile.in
	chroot_check $? "sed fix"
}

config() {
	./configure --prefix=/usr --sysconfdir=/etc
	chroot_check $? "configure"
}

build() {
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
	make install
	chroot_check $? "make install"

	gtk-query-immodules-2.0 --update-cache
	chroot_check $? "gtk-query-immodules-2.0"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?



