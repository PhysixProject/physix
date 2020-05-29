#!/bin/bash
source /opt/physix/include.sh || exit 1


su physix -c './configure --prefix=/usr'
chroot_check $? "configure"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install &&
sed -i 's/Utility;//' /usr/share/applications/gpicview.desktop
chroot_check $? "make install"

