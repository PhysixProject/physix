#!/bin/bash
source ../include.sh || exit 1

prep() {
	sed -e '/noinst_SCRIPTS = gpg-zip/c sbin_SCRIPTS += gpg-zip' \
    	-i tools/Makefile.in
}

config() {
	./configure --prefix=/usr \
              --enable-symcryptrun      \
              --localstatedir=/var      \
              --docdir=/usr/share/doc/gnupg-2.2.17
	chroot_check $? "GnuPG : configure"
}

build() {
	make -j$NPROC &&
    makeinfo --html --no-split -o doc/gnupg_nochunks.html doc/gnupg.texi &&
    makeinfo --plaintext       -o doc/gnupg.txt           doc/gnupg.texi &&
    make -C doc html
	chroot_check $? "GnuPG : make"
}

build_install() {
	#make check
	#chroot_check $? "GnuPG : make check"

	make install &&
	install -v -m755 -d /usr/share/doc/gnupg-2.2.17/html            &&
	install -v -m644    doc/gnupg_nochunks.html \
        	            /usr/share/doc/gnupg-2.2.17/html/gnupg.html &&
	install -v -m644    doc/*.texi doc/gnupg.txt \
       		            /usr/share/doc/gnupg-2.2.17 &&
	install -v -m644    doc/gnupg.html/* \
        	            /usr/share/doc/gnupg-2.2.17/html
	chroot_check $? "GnuPG : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

