#!/bin/bash
source ../include.sh || exit 1

prep() {
	# this will have to change
	install  -v -m700 -d /var/lib/sshd &&
	chown    -v root:sys /var/lib/sshd 

	grep sshd /etc/group
	if [ $? -ne 0 ] ; then
		groupadd -g 50 sshd &&
		useradd  -c 'sshd PrivSep' \
		-d /var/lib/sshd  \
		-g sshd           \
		-s /bin/false     \
		-u 50 sshd
	fi
	chroot_check $? "openssh : useradd sshd" NOEXIT
}

config() {
	./configure --prefix=/usr --sysconfdir=/etc/ssh --with-md5-passwords --with-privsep-path=/var/lib/sshd --with-pam
	chroot_check $? "openssh : configure"
}

build() {
	make
	chroot_check $? "openssh : make"
}

build_install() {
	make install &&
	install -v -m755    contrib/ssh-copy-id /usr/bin     &&
	install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1              &&
	install -v -m755 -d /usr/share/doc/openssh-8.0p1     &&
	install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-8.0p1
	chroot_check $? "openssh : make install"

	install -m644 /opt/admin/physix/build-scripts/04-utils/configs/openssh/sshd.service   /lib/systemd/system/sshd.service &&
	install -m644 /opt/admin/physix/build-scripts/04-utils/configs/openssh/sshdat.service /lib/systemd/system/sshd@.service &&
	install -m644 /opt/admin/physix/build-scripts/04-utils/configs/openssh/sshd.socket    /lib/systemd/system/sshd.socket &&
	systemctl enable sshd.service
	chroot_check $? "systemctl enable sshd.service"
	systemctl restart sshd.service
	chroot_check $? "systemctl start sshd.service"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?


