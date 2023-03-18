#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies

prep() {
	exit 0
}

config() {
	exit 0
}

build() {
	exit 0
}

build_install() {
	SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
	source $SCRIPTPATH/../../include.sh
	source ~/.bashrc

	chown -R root:root $BUILDROOT/tools
	check $? "chown -R root:root $BUILDROOT/tools"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


