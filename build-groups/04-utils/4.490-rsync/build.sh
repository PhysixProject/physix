#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr --without-included-zlib
	chroot_check $? "rsync : configure"
}

build() {
	make
	chroot_check $? "rsync: make"
}

build_install() {
	make install
	chroot_check $? "rsync : make install"

	groupadd -g 48 rsyncd &&
	useradd -c "rsyncd Daemon" -d /home/rsync -g rsyncd \
	    -s /bin/false -u 48 rsyncd
	chroot_check $? "rsync : groupadd/useradd " NOEXIT
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

