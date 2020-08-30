#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr      \
            --sbindir=/sbin    \
            --disable-nftables \
            --enable-libipq    \
            --with-xtlibdir=/lib/xtables
	chroot_check $? "iptables : configure"
}

build() {
	make
	chroot_check $? "iptables : make"
}

build_install() {
	make install &&
	ln -sfv ../../sbin/xtables-legacy-multi /usr/bin/iptables-xml &&
	chroot_check $? "iptables : make install"

	for file in ip4tc ip6tc ipq iptc xtables
	do
	  mv -v /usr/lib/lib${file}.so.* /lib &&
	  ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
	  chroot_check $? "iptables : ln /usr/lib/lib${file}.so"
	done
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

