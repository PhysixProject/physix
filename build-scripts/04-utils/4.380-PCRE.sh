#!/bin/bash
source ../include.sh || exit 1


prep() {
        return 0
}

config() {
	./configure --prefix=/usr                     \
	            --docdir=/usr/share/doc/pcre-8.43 \
	            --enable-unicode-properties       \
	            --enable-pcre16                   \
	            --enable-pcre32                   \
        	    --enable-pcregrep-libz            \
	            --enable-pcregrep-libbz2          \
        	    --enable-pcretest-libreadline     \
	            --disable-static
	chroot_check $? "PCRE : configure"
}

build() {
	make
	chroot_check $? "PCRE : make"
}

build_install() {
	make install                     &&
	mv -v /usr/lib/libpcre.so.* /lib &&
	ln -sfv ../../lib/$(readlink /usr/lib/libpcre.so) /usr/lib/libpcre.so
	chroot_check $? "PCRE : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


