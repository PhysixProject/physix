#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	patch -Np1 -i ../libxslt-1.1.33-security_fix-1.patch
	sed -i s/3000/5000/ libxslt/transform.c doc/xsltproc.{1,xml}
	chroot_check $? "libxslt : prep"
}

config() {
	./configure --prefix=/usr --disable-static
	chroot_check $? "libxslt : configure"
}

build() {
	make
	chroot_check $? "libxslt : make"
}

build_install() {
	make install
	chroot_check $? "libxslt : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

