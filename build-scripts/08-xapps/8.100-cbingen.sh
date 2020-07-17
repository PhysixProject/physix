#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/rustc.sh

prep() {
	return 0
}

config() {
	return 0
}

build() {
	# FIXME: Running as physix user hits permissions issue.
	#su physix -c '/usr/bin/rustc/bin/cargo build --release'
	/usr/bin/rustc/bin/cargo build --release
	chroot_check $? "cargo build"
}

build_install() {
	install -Dm755 target/release/cbindgen /usr/bin/
	chroot_check $? "make install"
}



[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?
