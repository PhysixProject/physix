#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr
	chroot_check $? "libgcrypt : configure"
}

build() {
	make -j$NPROC
	chroot_check $? "libgcrypt : make"
}

build_install() {
	make -C doc html                                                       &&
	makeinfo --html --no-split -o doc/gcrypt_nochunks.html doc/gcrypt.texi &&
	makeinfo --plaintext       -o doc/gcrypt.txt           doc/gcrypt.texi
	chroot_check $? "libgcrypt : make doc"

	make install &&
	install -v -dm755   /usr/share/doc/libgcrypt-1.8.5 &&
	install -v -m644    README doc/{README.apichanges,fips*,libgcrypt*} \
        	            /usr/share/doc/libgcrypt-1.8.5 &&

	install -v -dm755   /usr/share/doc/libgcrypt-1.8.5/html &&
	install -v -m644 doc/gcrypt.html/* \
        	            /usr/share/doc/libgcrypt-1.8.5/html &&
	install -v -m644 doc/gcrypt_nochunks.html \
       		            /usr/share/doc/libgcrypt-1.8.5      &&
	install -v -m644 doc/gcrypt.{txt,texi} \
        	            /usr/share/doc/libgcrypt-1.8.5
	chroot_check $? "libgcrypt : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

