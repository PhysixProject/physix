#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd /sources/$1 || exit 1

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

