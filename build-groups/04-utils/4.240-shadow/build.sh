#!/bin/bash
source ../include.sh || exit 1

prep() {
	sed -i 's/groups$(EXEEXT) //' src/Makefile.in &&
	find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \; &&
	find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \; &&
	find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \; &&

	sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
        -e 's@/var/spool/mail@/var/mail@' etc/login.defs &&
	sed -i 's/1000/999/' etc/useradd
	chroot_check $? "shadow : sed Makefile.in"
}

config() {
	./configure --sysconfdir=/etc --with-group-name-max-length=32
	chroot_check $? "shadow : "
}

build() {
	make
	chroot_check $? "shadow : make"
}

build_install() {
	make install &&
	mv -v /usr/bin/passwd /bin
	chroot_check $? "shadow : make install"

	sed -i 's/yes/no/' /etc/default/useradd

	install -v -m644 /etc/login.defs /etc/login.defs.orig &&
	for FUNCTION in FAIL_DELAY               \
                FAILLOG_ENAB             \
                LASTLOG_ENAB             \
                MAIL_CHECK_ENAB          \
                OBSCURE_CHECKS_ENAB      \
                PORTTIME_CHECKS_ENAB     \
                QUOTAS_ENAB              \
                CONSOLE MOTD_FILE        \
                FTMP_FILE NOLOGINS_FILE  \
                ENV_HZ PASS_MIN_LEN      \
                SU_WHEEL_ONLY            \
                CRACKLIB_DICTPATH        \
                PASS_CHANGE_TRIES        \
                PASS_ALWAYS_WARN         \
                CHFN_AUTH ENCRYPT_METHOD \
                ENVIRON_FILE
	do
	    sed -i "s/^${FUNCTION}/# &/" /etc/login.defs
	    chroot_check $? "shadow : sed functions"
	done

	cp -v $PKG_DIR_PATH/login /etc/pam.d/           &&
	cp -v $PKG_DIR_PATH/su /etc/pam.d/              &&
	cp -v $PKG_DIR_PATH/ssh /etc/pam.d/             &&
	cp -v $PKG_DIR_PATH/groupadd /etc/pam.d/        &&
	cp -v $PKG_DIR_PATH/useradd /etc/pam.d/         &&
	cp -v $PKG_DIR_PATH/passwd /etc/pam.d/          &&
	cp -v $PKG_DIR_PATH/system-auth /etc/pam.d/     &&
	cp -v $PKG_DIR_PATH/system-account /etc/pam.d/  &&
	cp -v $PKG_DIR_PATH/system-session /etc/pam.d/  &&
	cp -v $PKG_DIR_PATH/system-password /etc/pam.d/
	chroot_check $? "Writing /etc/pam.d/ config files"

	if [ -f /etc/login.access ] ; then
		mv -v /etc/login.access{,.NOUSE}
		chroot_check $? "shadow : mv /etc/login.access"
	fi

	if [ -f /etc/limits ] ; then
		mv -v /etc/limits{,.NOUSE}
		chroot_check $? "shadow : mv /etc/limits"
	fi
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

