#!/tools/bin/bash
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

./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2
chroot_check $? "system-build : pkg config  : config"

make -j8
chroot_check $? "system-build : pkg config  : make"

make check
chroot_check $? "system-build : pkg config : make check" noexit

make install
chroot_check $? "system-build : pkg config : make install"

rm -rfv /sources/$SRCD

