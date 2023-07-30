#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Tree Davies
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

sed -i 's/.m_ipt.o//' tc/Makefile

make
chroot_check $? "iproute make"

make DOCDIR=/usr/share/doc/iproute2-4.20.0 install
chroot_check $? "iproute make install"





