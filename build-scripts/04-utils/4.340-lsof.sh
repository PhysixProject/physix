#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	return 0
}

config() {
	tar -xf lsof_4.91_src.tar  &&
	cd lsof_4.91_src           &&
	./Configure -n linux       
	chroot_check $? "lsof : configure"
}

build() {
	cd lsof_4.91_src
	make CFGL="-L./lib -ltirpc"
	chroot_check $? "lsof : make"
}

build_install() {
	cd lsof_4.91_src
	install -v -m0755 -o root -g root lsof /usr/bin &&
	install -v lsof.8 /usr/share/man/man8
	chroot_check $? "lsof : install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


