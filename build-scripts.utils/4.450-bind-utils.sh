#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr --without-python'
chroot_check $? "bind-utils : configure"

su physix -c 'make -C lib/dns    &&
              make -C lib/isc    &&
              make -C lib/bind9  &&
              make -C lib/isccfg &&
              make -C lib/irs    &&
              make -C bin/dig'
chroot_check $? "bind-utils : make"

make -C bin/dig install
chroot_check $? "bind-utils : make install"

