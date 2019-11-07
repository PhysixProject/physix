#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

make install &&
install -vdm755 /etc/ssl/local
chroot_check $? "make-ca : make install"

#run if re-installing
/usr/sbin/make-ca -g
chroot_check $? "make-ca : /usr/sbin/make-ca -g"

rm -rf /sources/$SRCD

