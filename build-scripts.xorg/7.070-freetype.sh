#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/xc/$1 || exit 1

sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&

./configure --prefix=/usr --enable-freetype-config --disable-static &&
make
chroot_check $? "freetype : make "

make install
chroot_check $? "freetype : make install"

