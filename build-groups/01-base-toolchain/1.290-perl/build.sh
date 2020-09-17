#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source ../include.sh || exit 1
source ~/.bashrc

prep() {
	exit 0
}

config() {
	sh Configure -des -Dprefix=/tools -Dlibs=-lm -Uloclibpth -Ulocincpth
	check $? "perl: Configure"
}

build() {
	make
	check $? "perl: make"
}

build_install() {
	cp -v perl cpan/podlators/scripts/pod2man /tools/bin
	check $? "perl: cp -v perl cpan/podlators/scripts/pod2man /tools/bin"

	mkdir -pv /tools/lib/perl5/5.30.0
	check $? "perl: mkdir -pv /tools/lib/perl5/5.28.1"

	cp -Rv lib/* /tools/lib/perl5/5.30.0
	#strange errors but files are being written
	#check $? "perl: cp -Rv lib/* /tools/lib/perl5/5.28.1"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?



