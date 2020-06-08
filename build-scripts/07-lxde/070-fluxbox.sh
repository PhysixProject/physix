#!/bin/bash
source /opt/admin/physix/include.sh || exit 1


su physix -c './configure --prefix=/usr'
chroot_check $? "configure"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install 
chroot_check $? "make install"


echo startfluxbox > ~/.xinitrc

mkdir -pv /usr/share/xsessions &&
cat > /usr/share/xsessions/fluxbox.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Name=Fluxbox
Comment=This session logs you into Fluxbox
Exec=startfluxbox
Type=Application
EOF

