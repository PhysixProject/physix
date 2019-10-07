#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
chrooted-unpack $PKG
cd /sources/$SRCD

install  -v -m700 -d /var/lib/sshd &&
chown    -v root:sys /var/lib/sshd &&

groupadd -g 50 sshd        &&
useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd
check $? "openssh : useradd sshd"

./configure --prefix=/usr                     \
            --sysconfdir=/etc/ssh             \
            --with-md5-passwords              \
            --with-privsep-path=/var/lib/sshd 
check $? "openssh : configure"

make
check $? "openssh : make"

make install && 
install -v -m755    contrib/ssh-copy-id /usr/bin     && 
install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1              && 
install -v -m755 -d /usr/share/doc/openssh-8.0p1     && 
install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-8.0p1
check $? "openssh : make install"

rm -rfv /sources/$SRCD

