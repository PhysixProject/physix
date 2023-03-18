#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source ../include.sh || exit 1
source ~/.bashrc

prep() {
	exit 0
}

config() {
	./configure --prefix=/tools
	check $? "File configure"
}

build() {
	make
	check $? "File make"

	make check
	check $? "File make check" NOEXIT
}

build_install() {
	make install
	check $? "File make install"
}

