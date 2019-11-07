#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh                
cd /sources
PKG=$1              
stripit $PKG        
SRCD=$STRIPPED      
                    
cd /sources         
unpack $PKG
cd /sources/$SRCD   

./configure --prefix=/usr     \
            --bindir=/bin     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.4.48

chroot_check $? "system-build : acl : configure"

make -j8
chroot_check $? "system-build : acl : make"

make check
chroot_check $? "system-build : acl : make check" noexit

make install
chroot_check $? "system-build : acl : make install"

mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so

rm -rfv /sources/$SRCD

