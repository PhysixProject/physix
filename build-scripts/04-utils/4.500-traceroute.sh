#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	return 0
}

config() {
	return 0
}

build() {
	make
	chroot_check $? "traceroute : make"
}

build_install() {
	make prefix=/usr install                                 &&
	mv /usr/bin/traceroute /bin                              &&
	ln -sv -f traceroute /bin/traceroute6                    &&
	ln -sv -f traceroute.8 /usr/share/man/man8/traceroute6.8 &&
	rm -fv /usr/share/man/man1/traceroute.1
	chroot_check $? "traceroute : make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

