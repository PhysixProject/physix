#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr      \
            --sbindir=/sbin    \
            --disable-nftables \
            --enable-libipq    \
            --with-xtlibdir=/lib/xtables'
chroot_check $? "iptables : configure"

su physix -c 'make'
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

