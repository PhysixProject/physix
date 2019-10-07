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

./configure --prefix=/usr
chroot_check $? "system-build : psmisc : configure"

make -j8
chroot_check $? "system-build : psmisc : make"

make install
chroot_check $? "system-build : psmisc : make install"

mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin

rm -rfv /sources/$SRCD

