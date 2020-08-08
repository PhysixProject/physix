#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source $SCRIPTPATH/../../include.sh
source ~/.bashrc

prep() {
	exit 0
}

config() {
	exit 0
}

build(){
	exit 0
}

build_install() {
	# file format not recognized issue
	#strip --strip-debug /tools/lib/*
	check $? "strip --strip-debug /tools/lib/*"

	#fails
	#/usr/bin/strip --strip-unneeded /tools/{,s}bin/*
	#check $? "/usr/bin/strip --strip-unneeded /tools/{,s}bin/*"

	rm -rf /tools/{,share}/{info,man,doc}
	check $? "rm -rf /tools/{,share}/{info,man,doc}"

	find /tools/{lib,libexec} -name \*.la -delete
	check $? "find /tools/{lib,libexec} -name \*.la -delete"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?



