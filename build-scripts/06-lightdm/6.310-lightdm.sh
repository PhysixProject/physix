#!/bin/bash
source ../include.sh || exit 1

prep() {
	return 0
}

config() {
	./configure                  \
              --prefix=/usr                \
              --libexecdir=/usr/lib/lightdm \
              --localstatedir=/var          \
              --sbindir=/usr/bin            \
              --sysconfdir=/etc             \
              --disable-static              \
              --disable-tests               \
              --with-greeter-user=lightdm   \
              --with-greeter-session=lightdm-gtk-greeter \
              --docdir=/usr/share/doc/lightdm-1.30.0
	chroot_check $? "configure lightdm"
}

build() {
	make -j$NPROC
	chroot_check $? "make lightdm"
}

build_install() {

	grep -q lightdm /etc/group
	if [ $? -ne 0 ] ; then
        	groupadd -g 65 lightdm
        	chroot_check $? "add group lightdm"
	fi

	grep -q lightdm /etc/passwd
	if [ $? -ne 0 ] ; then
        	useradd  -c "Lightdm Daemon" -d /var/lib/lightdm -u 65 -g lightdm -s /bin/false lightdm
        	chroot_check $? "add user lightdm"
	fi

	make install                                                  &&
	cp tests/src/lightdm-session /usr/bin                         &&
	sed -i '1 s/sh/bash --login/' /usr/bin/lightdm-session        &&
	rm -rf /etc/init                                              &&
	install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm      &&
	install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm-data &&
	install -v -dm755 -o lightdm -g lightdm /var/cache/lightdm    &&
	install -v -dm770 -o lightdm -g lightdm /var/log/lightdm
	chroot_check $? "make install"
}



[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?
