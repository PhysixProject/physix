#!/bin/bash
source ../include.sh || exit 1

prep() {
	# IS THIS REQUIRED BEFORE COFNIG?
	grep -q mail /etc/group
	if [ $? -ne 0 ] ; then
        	groupadd -g 34 mail && chgrp -v mail /var/mail
	        chroot_check $? "mutt : groupadd -g 34 mail"
	fi
}

config() {
	cp -v doc/manual.txt{,.shipped} &&
            ./configure --prefix=/usr                \
            --sysconfdir=/etc                        \
            --with-docdir=/usr/share/doc/mutt-1.12.1 \
            --with-ssl                               \
            --enable-external-dotlock                \
            --enable-pop                             \
            --enable-imap                            \
            --enable-hcache                          \
            --enable-sidebar
	chroot_check $? "mutt : configure"
}

build() {
	make -j$NPROC
	chroot_check $? "mutt : make"
}

build_install() {
	make install &&
	test -s doc/manual.txt ||
	  install -v -m644 doc/manual.txt.shipped \
	  /usr/share/doc/mutt-1.12.1/manual.txt
	chroot_check $? "mutt : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

