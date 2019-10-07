#!/bin/bash 
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh                
cd /sources
PKG=$1              
stripit $PKG        
SRCD=$STRIPPED      
                    
cd /sources         
chrooted-unpack $PKG
cd /sources/$SRCD   

sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in


sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h


./configure --prefix=/usr --localstatedir=/var/lib/locate
chroot_check $? "findutils configure"

make
chroot_check $? "findutils make"

make check
chroot_check $? "findutils make check" noexit

make install
chroot_check $? "findutils make install"

mv -v /usr/bin/find /bin
sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb

rm -rfv /sources/$SRCD

