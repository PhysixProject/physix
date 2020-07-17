#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	return 0
}

config() {
	#cd ../speexdsp-1.2rc3 || exit 1
	./configure --prefix=/usr \
            --disable-static \
            --docdir=/usr/share/doc/speexdsp-1.2rc3
	chroot_check $? "configure speex dsp"
}

build() {
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
	make install
	chroot_check $? "make install speex dsp"
}


[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?
