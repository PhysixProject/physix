#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd /sources/$1 || exit 1

install  -v -m700 -d /var/lib/sshd &&
chown    -v root:sys /var/lib/sshd &&

groupadd -g 50 sshd        &&
useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd
chroot_check $? "openssh : useradd sshd" NOEXIT

./configure --prefix=/usr                     \
            --sysconfdir=/etc/ssh             \
            --with-md5-passwords              \
            --with-privsep-path=/var/lib/sshd
chroot_check $? "openssh : configure"

make
chroot_check $? "openssh : make"

make install &&
install -v -m755    contrib/ssh-copy-id /usr/bin     &&
install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1              &&
install -v -m755 -d /usr/share/doc/openssh-8.0p1     &&
install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-8.0p1
chroot_check $? "openssh : make install"

install -m 754 /physix/build-scripts.utils/configs/sshd/sshd.init /etc/rc.d/init.d/sshd &&
ln -sf  /etc/init.d/sshd  /etc/rc.d/rc0.d/K30sshd     &&
ln -sf  /etc//init4.d/sshd /etc/rc.d/rc1.d/K30sshd    &&
ln -sf  /etc//init.d/sshd /etc/rc.d/rc2.d/K30sshd     &&
ln -sf  /etc/init.d/sshd  /etc/rc.d/rc3.d/S30sshd     &&
ln -sf  /ect/init.d/sshd  /etc/rc.d/rc4.d/S30sshd     &&
ln -sf  /etc/init.d/sshd  /etc/rc.d/rc5.d/S30sshd     &&
ln -sf  /etc/init.d/sshd  /etc/rc.d/rc6.d/K30sshd
chroot_check $? "4"

