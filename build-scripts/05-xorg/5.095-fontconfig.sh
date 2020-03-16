#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'sed -i "s/pthread-stubs//" configure && rm -f src/fcobjshash.h'

su physix -c "./configure --prefix=/usr \
            --sysconfdir=/etc           \
            --localstatedir=/var        \
            --disable-docs              \
            --docdir=/usr/share/doc/fontconfig-2.13.1 "

su physix -c 'make'
chroot_check $? "fontconfig : make "

make install
chroot_check $? "fontconfig : make install"

