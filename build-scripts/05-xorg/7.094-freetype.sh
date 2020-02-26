#!/bin/bash
source /physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 3

su physix -c 'sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg'
chroot_check $? "sed modules.cfg"
su physix -c 'sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" -i include/freetype/config/ftoption.h'
chroot_check $? "sed ftoption.h"

su physix -c "./configure --prefix=/usr --enable-freetype-config --disable-static" 
chroot_check $? "configure"

su physix -c 'make'
chroot_check $? 'make'

make install
chroot_check $? "make install"

