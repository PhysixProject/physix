#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr --disable-static'
chroot_check $? "nettle : configure"

su physix -c 'make'
chroot_check $? "nettle : make"

make install &&
chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
install -v -m755 -d /usr/share/doc/nettle-3.5.1 &&
install -v -m644 nettle.html /usr/share/doc/nettle-3.5.1
chroot_check $? "nettle : make install"

