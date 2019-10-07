#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /mnt/lfs/physix/include.sh
source ~/.bashrc


cd /mnt/lfs/sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

unpack $PKG
cd /mnt/lfs/sources/$SRCD   

mkdir -v build                                                                  
cd       build                                                                  
                                                                                
../configure --prefix=/tools --with-sysroot=$LFS --with-lib-path=/tools/lib --target=$LFS_TGT --disable-nls --disable-werror  
check $? "Binutils Configure"

make -j8
check $? "Binutils make"

                                                                                
case $(uname -m) in                                                             
  x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;                     
esac                                                                            
                                                                                
make install 
check $? "Binutils make install"

rm -rf /mnt/lfs/sources/$SRCD
exit 0    
