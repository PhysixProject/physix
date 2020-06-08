#!/bin/bash
source /opt/admin/physix/include.sh || exit 1


su physix -c "sed -ri \"s:.*(AUX_MODULES.*valid):\1:\" modules.cfg"
chroot_check $? 'sed 1'

su physix -c "sed -r \"s:.*(#.*SUBPIXEL_RENDERING) .*:\1:\" -i include/freetype/config/ftoption.h"
chroot_check $? 'sed 2'

su physix -c './configure --prefix=/usr --enable-freetype-config --disable-static'
chroot_check $? 'configure'

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install 
chroot_check $? 'make install'


