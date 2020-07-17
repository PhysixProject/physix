#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure --prefix=/usr
	chroot_check $? "configure"
}

build() {
	make -j$NPROC
	chroot_check $? "make"
}

build_install() {
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
}


[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


