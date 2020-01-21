#!/bin/bash

source /physix/include.sh

cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd $SOURCE_DIR/$SRCD

groupadd -g 51 stunnel &&
useradd -c "stunnel Daemon" -d /var/lib/stunnel \
        -g stunnel -s /bin/false -u 51 stunnel
chroot_check $? "stunnel : group/user add"

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-systemd
chroot_check $? "stunnel : configure"

make
chroot_check $? "stunnel : make"

make docdir=/usr/share/doc/stunnel-5.55 install
chroot_check $? "stunnel : make install docs"

make cert
chroot_check $? "stunnel : make cert"

install -v -m750 -o stunnel -g stunnel -d /var/lib/stunnel/run &&
chown stunnel:stunnel /var/lib/stunnel
chroot_check $? "stunnel : install /var/lib/stunnel/run, and /var/lib/stunnel"

cat >/etc/stunnel/stunnel.conf << "EOF"
; File: /etc/stunnel/stunnel.conf

; Note: The pid and output locations are relative to the chroot location.

pid    = /run/stunnel.pid
chroot = /var/lib/stunnel
client = no
setuid = stunnel
setgid = stunnel
cert   = /etc/stunnel/stunnel.pem

;debug = 7
;output = stunnel.log

;[https]
;accept  = 443
;connect = 80
;; "TIMEOUTclose = 0" is a workaround for a design flaw in Microsoft SSL
;; Microsoft implementations do not use SSL close-notify alert and thus
;; they are vulnerable to truncation attacks
;TIMEOUTclose = 0

EOF
chroot_check $? "stunnel : /etc/stunnel/stunnel.conf written"

make install-stunnel
chroot_check $? "stunnel : make install-stunnel"

