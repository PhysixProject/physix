#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr
	chroot_check $? "libassuan : configure"
}

build() {
	make -j$NPROC      &&
	make -C doc html   &&
	makeinfo --html --no-split -o doc/assuan_nochunks.html doc/assuan.texi &&
	makeinfo --plaintext       -o doc/assuan.txt           doc/assuan.texi
	chroot_check $? "libassuan : make"
}

build_install() {
	make install &&
	install -v -dm755   /usr/share/doc/libassuan-2.5.3/html &&
	install -v -m644 doc/assuan.html/* \
        	            /usr/share/doc/libassuan-2.5.3/html &&
	install -v -m644 doc/assuan_nochunks.html \
        	            /usr/share/doc/libassuan-2.5.3      &&
	install -v -m644 doc/assuan.{txt,texi} \
        	            /usr/share/doc/libassuan-2.5.3
	chroot_check $? "libassuan : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

