#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh

cd /sources
PKG=$1                                                                          
stripit $PKG                                                                    
SRCD=$STRIPPED                                                                  
                                                                                
chrooted-unpack $PKG                                                            
cd /sources/$SRCD 

make install
chroot_check $? "system-build : man pages: make install "

rm -rfv /sources/$SRCD

