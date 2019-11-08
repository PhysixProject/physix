#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD


./configure  
chroot_check $? "tmux : configure"

make
chroot_check $? "tmux : make"

make install
chroot_check $? "tmux : make install"

rm -rf /sources/$SRCD

