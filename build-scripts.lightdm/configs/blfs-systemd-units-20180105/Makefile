SHELL=/bin/bash

EXTDIR=${DESTDIR}/etc
DEFAULTSDIR=${DESTDIR}/etc/default
SERVICEDIR=${DESTDIR}/lib/services
TMPFILESDIR=${DESTDIR}/usr/lib/tmpfiles.d
UNITSDIR=${DESTDIR}/lib/systemd/system
MODE=755
DIRMODE=755
CONFMODE=644

all:
	@grep "^install" Makefile.systemd | cut -d ":" -f 1
	@echo "Select an appropriate install target from the above list"

create-dirs:
	install -d -m ${DIRMODE} ${DEFAULTSDIR}
	install -d -m ${DIRMODE} ${TMPFILESDIR}
	install -d -m ${DIRMODE} ${UNITSDIR}

create-service-dir:
	install -d -m ${DIRMODE} ${EXTDIR}/sysconfig/network-devices/services
	install -d -m ${DIRMODE} ${SERVICEDIR}

install-service-dhclient: create-service-dir
	install -m ${MODE} blfs/services/dhclient ${SERVICEDIR}

install-service-dhcpcd: create-service-dir
	install -m ${MODE} blfs/services/dhcpcd  ${SERVICEDIR}

install-service-bridge: create-service-dir
	install -m ${MODE} blfs/services/bridge  ${SERVICEDIR}

install-service-wpa: create-service-dir
	install -m ${MODE} blfs/services/wpa ${SERVICEDIR}

install-acpid: create-dirs
	install -m ${CONFMODE} blfs/units/acpid.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/acpid.socket ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable acpid.socket

install-dhclient: create-dirs
	install -m ${CONFMODE} blfs/units/dhclientat.service ${UNITSDIR}/dhclient@.service

install-dhcpcd: create-dirs
	install -m ${CONFMODE} blfs/units/dhcpcdat.service ${UNITSDIR}/dhcpcd@.service

install-dhcpd: create-dirs
	install -m ${CONFMODE} blfs/default/dhcpd ${DEFAULTSDIR}/
	install -m ${CONFMODE} blfs/units/dhcpd.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable dhcpd.service

install-exim: create-dirs
	install -m ${CONFMODE} blfs/units/exim.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable exim.service

install-git: create-dirs
	install -m ${CONFMODE} blfs/units/git-daemonat.service ${UNITSDIR}/git-daemon@.service
	install -m ${CONFMODE} blfs/units/git-daemon.socket ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable git-daemon.socket

install-gpm: create-dirs
	install -m ${CONFMODE} blfs/units/gpm.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable gpm.service

install-haveged: create-dirs
	install -m ${CONFMODE} blfs/units/haveged.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable haveged.service

install-httpd: create-dirs
	install -m ${CONFMODE} blfs/tmpfiles/httpd.conf ${TMPFILESDIR}/
	install -m ${CONFMODE} blfs/units/httpd.service ${UNITSDIR}/
	systemd-tmpfiles --create httpd.conf
	test -n "${DESTDIR}" || systemctl enable httpd.service

install-iptables: create-dirs
	install -m ${CONFMODE} blfs/units/iptables.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable iptables.service

install-kdm: create-dirs
	install -m ${CONFMODE} blfs/units/kdm.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable kdm.service

install-krb5: create-dirs
	install -m ${CONFMODE} blfs/units/krb5-kdc.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/krb5-kpropd.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/krb5-kadmind.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable krb5-kdc.service
	test -n "${DESTDIR}" || systemctl enable krb5-kpropd.service
	test -n "${DESTDIR}" || systemctl enable krb5-kadmind.service

install-lightdm: create-dirs
	install -m ${CONFMODE} blfs/units/lightdm.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable lightdm.service

install-mysqld: create-dirs
	install -m ${CONFMODE} blfs/tmpfiles/mysqld.conf ${TMPFILESDIR}/
	install -m ${CONFMODE} blfs/units/mysqld.service ${UNITSDIR}/
	systemd-tmpfiles --create mysqld.conf
	test -n "${DESTDIR}" || systemctl enable mysqld.service

install-named: create-dirs
	install -m ${CONFMODE} blfs/tmpfiles/named.conf ${TMPFILESDIR}/
	install -m ${CONFMODE} blfs/units/named.service ${UNITSDIR}/
	systemd-tmpfiles --create named.conf
	test -n "${DESTDIR}" || systemctl enable named.service

install-nfs-client: create-dirs
	install -m ${CONFMODE} blfs/default/nfs-utils ${DEFAULTSDIR}/
	install -m ${CONFMODE} blfs/units/rpc-statd.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/rpc-statd-notify.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/nfs-client.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/nfs-client.target ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable nfs-client.target

install-nfs-server: install-nfs-client
	install -m ${CONFMODE} blfs/units/nfs-server.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/rpc-mountd.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/proc-fs-nfsd.mount ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable nfs-server.service

install-nfsv4-server: install-nfs-server
	install -m ${CONFMODE} blfs/units/rpc-idmapd.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/var-lib-nfs-rpc_pipefs.mount ${UNITSDIR}/

install-ntpd: create-dirs
	install -m ${CONFMODE} blfs/units/ntpd.service ${UNITSDIR}/
	install -d -m ${DIRMODE} ${DESTDIR}/usr/lib/systemd/ntp-units.d
	test -n "${DESTDIR}" || systemctl enable ntpd.service

install-php-fpm: create-dirs
	install -m ${CONFMODE} blfs/units/php-fpm.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable php-fpm.service

install-postfix: create-dirs
	install -m ${CONFMODE} blfs/units/postfix.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable postfix.service

install-postgresql: create-dirs
	install -m ${CONFMODE} blfs/tmpfiles/postgresql.conf ${TMPFILESDIR}/
	install -m ${CONFMODE} blfs/units/postgresql.service ${UNITSDIR}/
	systemd-tmpfiles --create postgresql.conf
	test -n "${DESTDIR}" || systemctl enable postgresql.service

install-proftpd: create-dirs
	install -m ${CONFMODE} blfs/units/proftpd.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable proftpd.service

install-rpcbind: create-dirs
	install -m ${CONFMODE} blfs/units/rpcbind.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/rpcbind.socket ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable rpcbind.socket

install-rsyncd: create-dirs
	install -m ${CONFMODE} blfs/units/rsyncd.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/rsyncdat.service ${UNITSDIR}/rsyncd@.service
	install -m ${CONFMODE} blfs/units/rsyncd.socket ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable rsyncd.service

install-samba: create-dirs
	install -m ${CONFMODE} blfs/default/samba ${DEFAULTSDIR}/
	install -m ${CONFMODE} blfs/tmpfiles/samba.conf ${TMPFILESDIR}/
	install -m ${CONFMODE} blfs/units/nmbd.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/samba.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/smbd.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/smbdat.service ${UNITSDIR}/smbd@.service
	install -m ${CONFMODE} blfs/units/smbd.socket ${UNITSDIR}/
	systemd-tmpfiles --create samba.conf
	test -n "${DESTDIR}" || systemctl enable nmbd.service
	test -n "${DESTDIR}" || systemctl enable smbd.service

install-saslauthd: create-dirs
	install -m ${CONFMODE} blfs/default/saslauthd ${DEFAULTSDIR}/
	install -m ${CONFMODE} blfs/tmpfiles/saslauthd.conf ${TMPFILESDIR}/
	install -m ${CONFMODE} blfs/units/saslauthd.service ${UNITSDIR}/
	systemd-tmpfiles --create saslauthd.conf
	test -n "${DESTDIR}" || systemctl enable saslauthd.service

install-sendmail: create-dirs
	install -m ${CONFMODE} blfs/default/sendmail ${DEFAULTSDIR}/
	install -m ${CONFMODE} blfs/units/sm-client.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/sendmail.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable sendmail.service

install-slapd: create-dirs
	install -m ${CONFMODE} blfs/default/slapd ${DEFAULTSDIR}/
	install -m ${CONFMODE} blfs/tmpfiles/slapd.conf ${TMPFILESDIR}/
	install -m ${CONFMODE} blfs/units/slapd.service ${UNITSDIR}/
	systemd-tmpfiles --create slapd.conf
	test -n "${DESTDIR}" || systemctl enable slapd.service

install-sshd: create-dirs
	install -m ${CONFMODE} blfs/units/sshd.service ${UNITSDIR}/
	install -m ${CONFMODE} blfs/units/sshdat.service ${UNITSDIR}/sshd@.service
	install -m ${CONFMODE} blfs/units/sshd.socket ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable sshd.service

install-svnserve: create-dirs
	install -m ${CONFMODE} blfs/default/svnserve ${DEFAULTSDIR}/
	install -m ${CONFMODE} blfs/tmpfiles/svnserve.conf ${TMPFILESDIR}/
	install -m ${CONFMODE} blfs/units/svnserve.service ${UNITSDIR}/
	systemd-tmpfiles --create svnserve.conf
	test -n "${DESTDIR}" || systemctl enable svnserve.service

install-unbound: create-dirs
	install -m ${CONFMODE} blfs/units/unbound.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable unbound.service

install-vsftpd: create-dirs
	install -m ${CONFMODE} blfs/units/vsftpd.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable vsftpd.service

install-winbindd: install-samba
	install -m ${CONFMODE} blfs/units/winbindd.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable winbindd.service

install-xinetd: create-dirs
	install -m ${CONFMODE} blfs/units/xinetd.service ${UNITSDIR}/
	test -n "${DESTDIR}" || systemctl enable xinetd.service

uninstall-acpid:
	test -n "${DESTDIR}" || systemctl stop acpid.service
	test -n "${DESTDIR}" || systemctl disable acpid.socket
	rm -f ${UNITSDIR}/acpid.service ${UNITSDIR}/acpid.socket

uninstall-dhclient:
	rm -f ${UNITSDIR}/dhclient@.service

uninstall-dhcpcd:
	rm -f ${UNITSDIR}/dhcpcd@.service

uninstall-dhcpd:
	test -n "${DESTDIR}" || systemctl stop dhcpd.service
	test -n "${DESTDIR}" || systemctl disable dhcpd.service
	rm -f ${DEFAULTSDIR}/dhcpd ${UNITSDIR}/dhcpd.service

uninstall-exim:
	test -n "${DESTDIR}" || systemctl stop exim.service
	test -n "${DESTDIR}" || systemctl disable exim.service
	rm -f ${UNITSDIR}/exim.service

uninstall-git:
	test -n "${DESTDIR}" || systemctl stop git-daemon.socket
	test -n "${DESTDIR}" || systemctl disable git-daemon.socket
	rm -f ${UNITSDIR}/git-daemon@.service ${UNITSDIR}/git-daemon.socket

uninstall-gpm:
	test -n "${DESTDIR}" || systemctl stop gpm.service
	test -n "${DESTDIR}" || systemctl disable gpm.service
	rm -f ${UNITSDIR}/gpm.service

uninstall-haveged:
	test -n "${DESTDIR}" || systemctl stop haveged.service
	test -n "${DESTDIR}" || systemctl disable haveged.service
	rm -f ${UNITSDIR}/haveged.service

uninstall-httpd:
	test -n "${DESTDIR}" || systemctl stop httpd.service
	test -n "${DESTDIR}" || systemctl disable httpd.service
	rm -f ${TMPFILESDIR}/httpd.conf ${UNITSDIR}/httpd.service

uninstall-iptables:
	test -n "${DESTDIR}" || systemctl disable iptables.service
	rm -f ${UNITSDIR}/iptables.service

uninstall-kdm:
	test -n "${DESTDIR}" || systemctl stop kdm.service
	test -n "${DESTDIR}" || systemctl disable kdm.service
	rm -f ${UNITSDIR}/kdm.service

uninstall-krb5:
	test -n "${DESTDIR}" || systemctl stop krb5-kadmind.service
	test -n "${DESTDIR}" || systemctl stop krb5-kpropd.service
	test -n "${DESTDIR}" || systemctl stop krb5-kdc.service
	test -n "${DESTDIR}" || systemctl disable krb5-kadmind.service
	test -n "${DESTDIR}" || systemctl disable krb5-kpropd.service
	test -n "${DESTDIR}" || systemctl disable krb5-kdc.service
	rm -f ${UNITSDIR}/krb5-kadmind.service ${UNITSDIR}/krb5-kpropd.service ${UNITSDIR}/krb5-kdc.service

uninstall-lightdm:
	test -n "${DESTDIR}" || systemctl stop lightdm.service
	test -n "${DESTDIR}" || systemctl disable lightdm.service
	rm -f ${UNITSDIR}/lightdm.service

uninstall-mysqld:
	test -n "${DESTDIR}" || systemctl stop mysqld.service
	test -n "${DESTDIR}" || systemctl disable mysqld.service
	rm -f ${TMPFILESDIR}/mysqld.conf ${UNITSDIR}/mysqld.service

uninstall-named:
	test -n "${DESTDIR}" || systemctl stop named.service
	test -n "${DESTDIR}" || systemctl disable named.service
	rm -f ${TMPFILESDIR}/named.conf ${UNITSDIR}/named.service

uninstall-nfs-client: uninstall-nfs-server
	test -n "${DESTDIR}" || systemctl stop nfs-client.target
	test -n "${DESTDIR}" || systemctl disable nfs-client.target
	rm -f ${DEFAULTSDIR}/nfs-utils ${UNITSDIR}/nfs-client.target
	rm -f ${UNITSDIR}/nfs-client.service ${UNITSDIR}/rpc-statd.service ${UNITSDIR}/rpc-statd-notify.service

uninstall-nfs-server: uninstall-nfsv4-server
	if [[ -z "${DESTDIR}" ]]; then test -e "${UNITSDIR}/nfs-server.service" && systemctl stop nfs-server.service; fi
	if [[ -z "${DESTDIR}" ]]; then test -e "${UNITSDIR}/nfs-server.service" && systemctl disable nfs-server.service; fi
	rm -f ${UNITSDIR}/nfs-server.service ${UNITSDIR}/rpc-mountd.service
	rm -f ${UNITSDIR}/proc-fs-nfsd.mount

uninstall-nfsv4-server:
	rm -f ${UNITSDIR}/rpc-idmapd.service
	rm -f ${UNITSDIR}/var-lib-nfs-rpc_pipefs.mount

uninstall-ntpd:
	test -n "${DESTDIR}" || systemctl stop ntpd.service
	test -n "${DESTDIR}" || systemctl disable ntpd.service
	rm -f ${UNITSDIR}/ntpd.service

uninstall-php-fpm:
	test -n "${DESTDIR}" || systemctl stop php-fpm.service
	test -n "${DESTDIR}" || systemctl disable php-fpm.service
	rm -f ${UNITSDIR}/php-fpm.service

uninstall-postfix:
	test -n "${DESTDIR}" || systemctl stop postfix.service
	test -n "${DESTDIR}" || systemctl disable postfix.service
	rm -f ${UNITSDIR}/postfix.service

uninstall-postgresql:
	test -n "${DESTDIR}" || systemctl stop postgresql.service
	test -n "${DESTDIR}" || systemctl disable postgresql.service
	rm -f ${TMPFILESDIR}/postgresql.conf ${UNITSDIR}/postgresql.service

uninstall-proftpd:
	test -n "${DESTDIR}" || systemctl stop proftpd.service
	test -n "${DESTDIR}" || systemctl disable proftpd.service
	rm -f ${UNITSDIR}/proftpd.service

uninstall-rpcbind:
	test -n "${DESTDIR}" || systemctl stop rpcbind.socket
	test -n "${DESTDIR}" || systemctl disable rpcbind.socket
	rm -f ${UNITSDIR}/rpcbind.service ${UNITSDIR}/rpcbind.socket

uninstall-rsyncd:
	test -n "${DESTDIR}" || systemctl stop rsyncd.socket
	test -n "${DESTDIR}" || systemctl stop rsyncd.service
	rm -f ${UNITSDIR}/rsyncd.service ${UNITSDIR}/rsyncd@.service
	rm -f ${UNITSDIR}/rsyncd.socket

uninstall-samba: uninstall-winbindd
	test -n "${DESTDIR}" || systemctl stop smbd.socket
	test -n "${DESTDIR}" || systemctl stop smbd.service
	test -n "${DESTDIR}" || systemctl stop nmbd.service
	test -n "${DESTDIR}" || systemctl disable smbd.socket
	test -n "${DESTDIR}" || systemctl disable smbd.service
	test -n "${DESTDIR}" || systemctl disable nmbd.service
	rm -f ${DEFAULTSDIR}/samba ${TMPFILESDIR}/samba.conf ${UNITSDIR}/nmbd.service
	rm -f ${UNITSDIR}/smbd.service ${UNITSDIR}/smbd@.service ${UNITSDIR}/smbd.socket

uninstall-saslauthd:
	test -n "${DESTDIR}" || systemctl stop saslauthd.service
	test -n "${DESTDIR}" || systemctl disable saslauthd.service
	rm -f ${DEFAULTSDIR}/saslauthd ${TMPFILESDIR}/saslauthd.conf ${UNITSDIR}/saslauthd.service

uninstall-sendmail:
	test -n "${DESTDIR}" || systemctl stop sendmail.service
	test -n "${DESTDIR}" || systemctl disable sendmail.service
	rm -f ${DEFAULTSDIR}/sendmail ${UNITSDIR}/sm-client.service ${UNITSDIR}/sendmail.service

uninstall-slapd:
	test -n "${DESTDIR}" || systemctl stop slapd.service
	test -n "${DESTDIR}" || systemctl disable slapd.service
	rm -f ${DEFAULTSDIR}/slapd ${TMPFILESDIR}/slapd.conf ${UNITSDIR}/slapd.service

uninstall-sshd:
	test -n "${DESTDIR}" || systemctl stop sshd.socket
	test -n "${DESTDIR}" || systemctl stop sshd.service
	test -n "${DESTDIR}" || systemctl disable sshd.socket
	test -n "${DESTDIR}" || systemctl disable sshd.service
	rm -f ${UNITSDIR}/sshd.service ${UNITSDIR}/sshd@.service ${UNITSDIR}/sshd.socket

uninstall-svnserve:
	test -n "${DESTDIR}" || systemctl stop svnserve.service
	test -n "${DESTDIR}" || systemctl disable svnserve.service
	rm -f ${DEFAULTSDIR}/svnserve ${TMPFILESDIR}/svnserve.conf ${UNITSDIR}/svnserve.service

uninstall-unbound:
	test -n "${DESTDIR}" || systemctl stop unbound.service
	test -n "${DESTDIR}" || systemctl disable unbound.service
	rm -f ${UNITSDIR}/unbound.service

uninstall-vsftpd:
	test -n "${DESTDIR}" || systemctl stop vsftpd.service
	test -n "${DESTDIR}" || systemctl disable vsftpd.service
	rm -f ${UNITSDIR}/vsftpd.service

uninstall-winbindd:
	test -n "${DESTDIR}" || systemctl stop winbindd.service
	test -n "${DESTDIR}" || systemctl disable winbindd.service
	rm -f ${UNITSDIR}/winbindd.service

uninstall-xinetd:
	test -n "${DESTDIR}" || systemctl stop xinetd.service
	test -n "${DESTDIR}" || systemctl disable xinetd.service
	rm -f ${UNITSDIR}/xinetd.service

.PHONY: all create-dirs create-service-dir \
	install-acpid \
	install-dhclient \
	install-dhcpcd \
	install-dhcpd \
	install-exim \
	install-git \
	install-gpm \
	install-httpd \
	install-iptables \
	install-kdm \
	install-krb5 \
	install-mysqld \
	install-named \
	install-nfs-client \
	install-nfs-server \
	install-nfsv4-server \
	install-ntp \
	install-php-fpm \
	install-postfix \
	install-postgresql \
	install-proftpd \
	install-rpcbind \
	install-rsyncd \
	install-samba \
	install-saslauthd \
	install-sendmail \
	install-slapd \
	install-sshd \
	install-svnserve \
	install-unbound \
	install-vsftpd \
	install-winbindd \
	install-xinetd \
	uninstall-acpid \
	uninstall-dhclient \
	uninstall-dhcpcd \
	uninstall-dhcpd \
	uninstall-exim \
	uninstall-git \
	uninstall-gpm \
	uninstall-httpd \
	uninstall-iptables \
	uninstall-kdm \
	uninstall-krb5 \
	uninstall-mysqld \
	uninstall-named \
	uninstall-nfs-client \
	uninstall-nfs-server \
	uninstall-nfsv4-server \
	uninstall-ntpd \
	uninstall-php-fpm \
	uninstall-postfix \
	uninstall-postgresql \
	uninstall-proftpd \
	uninstall-rpcbind \
	uninstall-rsyncd \
	uninstall-samba \
	uninstall-saslauthd \
	uninstall-sendmail \
	uninstall-slapd \
	uninstall-sshd \
	uninstall-svnserve \
	uninstall-unbound \
	uninstall-vsftpd \
	uninstall-winbindd \
	uninstall-xinetd
