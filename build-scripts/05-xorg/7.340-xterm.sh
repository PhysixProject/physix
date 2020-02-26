#!/bin/bash
source /physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 3


su physix -c "sed -i '/v0/{n;s/new:/new:kb=^?:/}' termcap && printf '\tkbs=\\177,\n' >> terminfo"

su physix -c 'TERMINFO=/usr/share/terminfo \
./configure $XORG_CONFIG --with-app-defaults=/etc/X11/app-defaults'
chroot_check $? "./configure"

su physix -c 'make'
chroot_check $? "make"


make install    &&
make install-ti &&
mkdir -pv /usr/share/applications &&
cp -v *.desktop /usr/share/applications/
chroot_check $? "make install"

