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

echo "127.0.0.1 localhost $(hostname)" > /etc/hosts


export BUILD_ZLIB=False
export BUILD_BZIP2=0

sh Configure -des -Dprefix=/usr                 \
                  -Dvendorprefix=/usr           \
                  -Dman1dir=/usr/share/man/man1 \
                  -Dman3dir=/usr/share/man/man3 \
                  -Dpager="/usr/bin/less -isR"  \
                  -Duseshrplib                  \
                  -Dusethreads
chroot_check $? "system build : perl : confige"


make -j8
chroot_check $? "system build : perl : make"


make -k test
chroot_check $? "system build : perl : make test " noexit
# One test fails due to using the most recent version of gdbm. 


make install
chroot_check $? "system build : perl : make install"

unset BUILD_ZLIB BUILD_BZIP2

rm -rfv /sources/$SRCD

