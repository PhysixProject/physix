#!/bin/bash
source /physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 3

su physix -c "sed -i "s/pthread-stubs//" configure "
chroot_check $? "libxcb : sed -i "s/pthread-stubs//" configure"

su physix -c "./configure $XORG_CONFIG      \
            --without-doxygen \
            --docdir='${datadir}'/doc/libxcb-1.13.1"

su physix -c 'make'
chroot_check $? "libxcb :config / make"

make install
chroot_check $? "libxcb : make install"

