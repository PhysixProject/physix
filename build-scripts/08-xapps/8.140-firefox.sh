#!/bin/bash
source /opt/admin/physix/include.sh || exit 1


prep() {
	cp /opt/admin/physix/build-scripts/08-xapps/configs/firefox/mozconfig .
	chroot_check $? 'Write mozconfig'
}

config() {
	patch -Np1 -i ../firefox-68.5.0esr-system_graphite2_harfbuzz-1.patch
	chroot_check $? "patch"
}

build() {
	export PATH=$PATH:/usr/bin/rustc/bin ; export CC=gcc CXX=g++ && export MOZBUILD_STATE_PATH=${PWD}/mozbuild && 
		./mach build
	chroot_check $? 'configure'
}

build_install() {
	./mach install && mkdir -pv  /usr/lib/mozilla/plugins &&
	ln    -sfv ../../mozilla/plugins /usr/lib/firefox/browser/
	chroot_check $? 'make install'
}


[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?
