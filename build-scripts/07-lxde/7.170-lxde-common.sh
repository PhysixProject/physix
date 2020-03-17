#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr --sysconfdir=/etc'
chroot_check $? "configure"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install
chroot_check $? "make install"

/usr/bin/update-mime-database /usr/share/mime &&
/usr/bin/gtk-update-icon-cache -qf /usr/share/icons/hicolor 
#/usr/bin/update-desktop-database -q
chroot_check $? "update desktop db"


cat > ~/.xinitrc << "EOF"
# No need to run dbus-launch, since it is run by startlxde
startlxde
EOF


