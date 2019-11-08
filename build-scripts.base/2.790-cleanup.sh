#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh                

rm -rf /tmp/*

rm -f /usr/lib/lib{bfd,opcodes}.a
rm -f /usr/lib/libbz2.a
rm -f /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
rm -f /usr/lib/libltdl.a
rm -f /usr/lib/libfl.a
rm -f /usr/lib/libz.a

find /usr/lib /usr/libexec -name \*.la -delete

rm -vf /dummy.log
rm -vf /dummy.c
rm -vf /a.out
#rm -vf /sources
#rm -vf /tools

mv -v /sources.tar /usr/src

if [ -e /tools.tar ] ; then
	mv -v /tools.tar /usr/src
fi

