#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	return 0
}

build() {
	python2 setup.py build &&
	python3 setup.py build
	chroot_check $? "setup.p"
}

build_install() {
	python2 setup.py install --optimize=1   &&
	python2 setup.py install_pycairo_header &&
	python2 setup.py install_pkgconfig      &&
	python3 setup.py install --optimize=1   &&
	python3 setup.py install_pycairo_header &&
	python3 setup.py install_pkgconfig
	chroot_check $? "install"
}


[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

