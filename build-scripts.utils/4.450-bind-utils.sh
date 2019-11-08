#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

./configure --prefix=/usr --without-python 
chroot_check $? "bind-utils : configure"

make -C lib/dns    &&
make -C lib/isc    &&
make -C lib/bind9  &&
make -C lib/isccfg &&
make -C lib/irs    &&
make -C bin/dig
chroot_check $? "bind-utils : make"

make -C bin/dig install
chroot_check $? "bind-utils : make install"

rm -rf /sources/$SRCD

