#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
source $SCRIPTPATH/../include.sh
source ~/.bashrc

cd $BUILDROOT/sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

unpack $PKG NCHRT
cd $BUILDROOT/sources/$SRCD   

mkdir -v build                                                                  
cd       build                                                                  
                                                                                
../configure --prefix=/tools --with-sysroot=$BUILDROOT --with-lib-path=/tools/lib --target=$BUILDROOT_TGT --disable-nls --disable-werror  
check $? "Binutils Configure"

make -j8
check $? "Binutils make"

                                                                                
case $(uname -m) in                                                             
  x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;                     
esac                                                                            
                                                                                
make install 
check $? "Binutils make install"

rm -rf $BUILDROOT/sources/$SRCD
exit 0    
