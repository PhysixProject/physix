#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source ../include.sh || exit 1
source ~/.bashrc

prep() {
	sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
	check $? "Findutiles: sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c"

	sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
	check $? "Findutiles: sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c"

	echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h
	check $? "Findutils: echo #define _IO_IN_BACKUP 0x100 >> gl/lib/stdio-impl.h "
}

config() {
	./configure --prefix=/tools
	check $? "Findutils configure"
}

build() {
	make
	check $? "Findutils make"

	make check
	check $? "Findutils make check" NOEXIT
}

build_install() {
	make install
	check $? "Findutils make install"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


