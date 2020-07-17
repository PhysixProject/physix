#!/bin/bash
source /opt/admin/physix/include.sh || exit 1


prep() {
	return 0
}

config() {
	./configure --prefix=/usr --sysconfdir=/etc
	chroot_check $? "configure"
}

build() {
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
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

	cp /usr/share/xsessions/LXDE.desktop /usr/share/xsessions/default.desktop
	chroot_check $? "Set default desktop config"
}



[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

