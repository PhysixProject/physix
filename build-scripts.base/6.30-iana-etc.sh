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

make -j8 
chroot_check $? "system-build : iana-etc : make"

make install 
chroot_check $? "system-build : iana-etc : make install"

rm -rfv /sources/$SRCD

