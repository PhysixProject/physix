#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

./configure --prefix=/usr      \
            --sbindir=/sbin    \
            --disable-nftables \
            --enable-libipq    \
            --with-xtlibdir=/lib/xtables 
chroot_check $? "iptables : configure"

make
chroot_check $? "iptables : make"

make install &&
ln -sfv ../../sbin/xtables-legacy-multi /usr/bin/iptables-xml &&
chroot_check $? "iptables : make install"

for file in ip4tc ip6tc ipq iptc xtables
do
  mv -v /usr/lib/lib${file}.so.* /lib &&
  ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
  chroot_check $? "iptables : ln /usr/lib/lib${file}.so"
done

rm -rf /sources/$SRCD

