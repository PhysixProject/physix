#!/bin/bash
source ../include.sh || exit 1
source /etc/physix.conf || exit 1

prep(){
	sed -e '/^pre-install:/{N;s@;@ -a -r $(sudoersdir)/sudoers;@}' \
    	-i plugins/sudoers/Makefile.in
}

config() {
	./configure --prefix=/usr      \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.8.29 \
            --with-passprompt="[sudo] password for %p: "
	chroot_check $? "sudo : configure"
}

build() {
	make
	chroot_check $? "sudo : make"
}

build_install() {
	make install &&
	ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0
	chroot_check $? "sudo : make install"

cat > /etc/sudoers.d/sudo << "EOF"
Defaults secure_path="/usr/bin:/bin:/usr/sbin:/sbin"
%wheel ALL=(ALL) ALL
EOF
	chroot_check $? "sudo : /etc/sudoers.d/sudo written"

	GUSER=`echo $CONF_GEN_USER | cut -d'=' -f2`
	usermod -a -G wheel $GUSER
	chroot_check $? "sudo : Added $GUSER to wheel group"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

