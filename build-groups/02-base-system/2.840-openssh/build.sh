#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

install  -v -m700 -d /var/lib/sshd &&
chown    -v root:sys /var/lib/sshd &&

#TODO setup as part of /etc/passwd
groupadd -g 50 sshd        &&
useradd  -c 'sshd PrivSep' \
         -d /var/lib/sshd  \
         -g sshd           \
         -s /bin/false     \
         -u 50 sshd
chroot_check $? "openssh : useradd sshd" NOEXIT


./configure --prefix=/usr         \
            --sysconfdir=/etc/ssh \
            --with-md5-passwords  \
            --with-privsep-path=/var/lib/sshd
chroot_check $? "openssh : configure"


make
chroot_check $? "openssh : make"


make install &&
install -v -m755    contrib/ssh-copy-id /usr/bin     &&
install -v -m644    contrib/ssh-copy-id.1 \
                    /usr/share/man/man1              &&
install -v -m755 -d /usr/share/doc/openssh-8.3p1     &&
install -v -m644    INSTALL LICENCE OVERVIEW README* \
                    /usr/share/doc/openssh-8.3p1
chroot_check $? "openssh : make install"


install -m644 /opt/admin/physix/build-groups/04-utilities/configs/openssh/sshd.service   /lib/systemd/system/sshd.service &&
install -m644 /opt/admin/physix/build-groups/04-utilities/configs/openssh/sshdat.service /lib/systemd/system/sshd@.service &&
install -m644 /opt/admin/physix/build-groups/04-utilities/configs/openssh/sshd.socket    /lib/systemd/system/sshd.socket &&
systemctl enable sshd.service
chroot_check $? "systemctl enable sshd.service"

systemctl start sshd.service
chroot_check $? "systemctl start sshd.service"

