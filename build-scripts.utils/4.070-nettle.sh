#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd /sources/$1 || exit 1

./configure --prefix=/usr --disable-static 
chroot_check $? "nettle : configure" 

make
chroot_check $? "nettle : make"

make install &&
chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
install -v -m755 -d /usr/share/doc/nettle-3.5.1 &&
install -v -m644 nettle.html /usr/share/doc/nettle-3.5.1
chroot_check $? "nettle : make install"

