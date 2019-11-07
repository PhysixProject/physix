#!/bin/bash 
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

sed -i '5481,5485 s/({/(\\{/' tp/Texinfo/Parser.pm


./configure --prefix=/usr --disable-static
chroot_check $? "texinfo"

make
chroot_check $? "texinfo make" 

make check
chroot_check $? "texinfo make check" noexit 

make install
chroot_check $? "texinfo make install" 

make TEXMF=/usr/share/texmf install-tex
chroot_check $? "texinfo install texmf " 

pushd /usr/share/info
rm -v dir
for f in *
  do install-info $f dir 2>/dev/null
done
popd

rm -rfv /sources/$SRCD

