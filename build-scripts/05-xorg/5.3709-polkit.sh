#!/bin/bash
source /opt/admin/physix/include.sh || exit 1


prep() {
	return 0
}

config() {
        ./configure --prefix=/usr --sysconfdir=/etc  --localstatedir=/var  --disable-static   --with-os-type=PHYSIX    --enable-gtk-doc-html=no   --enable-man-pages=no --enable-examples=no
        chroot_check $? "config"

	#./configure --prefix=/usr \
        #    --sysconfdir=/etc    \
        #    --localstatedir=/var \
        #    --disable-static     \
        #    --with-os-type=PHYSIX 
	#chroot_check $? "configure "

	#sed -i 's/'-nonet'//' docs/man/Makefile.in  &&
	#sed -i 's/'-nonet'//' docs/man/Makefile     &&
	#sed -i 's/'-nonet'//' docs/man/Makefile.am
	#chroot_check $? "sed rm nonet switch"
}

build() {
	make
	chroot_check $? "make"
}

build_install() {

	#check before try
	groupadd -fg 27 polkitd &&
	useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 \
        	-g polkitd -s /bin/false polkitd
	chroot_check $? "user, group add"

	make install
	chroot_check $? "make install"

	cp /opt/admin/physix/build-scripts/05-xorg/configs/polkit/polkit-1  /etc/pam.d/
	chroot_check $? "wrote /etc/pam.d/polkit-1"

}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


