#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1
perl Makefile.PL

make -j8
chroot_check $? "system build : xmlparser : make"

make test
chroot_check $? "system build : xmlparser : make test" NOEXIT

make install
chroot_check $? "system build : xmlparser : make install"

