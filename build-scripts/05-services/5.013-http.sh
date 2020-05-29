#!/bin/bash
source /opt/physix/include.sh || exit 1

groupadd -g 25 apache &&
useradd -c "Apache Server" -d /srv/www -g apache -s /bin/false -u 25 apache

patch -Np1 -i ../httpd-2.4.41-blfs_layout-1.patch  &&
sed '/dir.*CFG_PREFIX/s@^@#@' -i support/apxs.in

su physix -c './configure --enable-authnz-fcgi                \
            --enable-layout=BLFS                              \
            --enable-mods-shared="all cgi"                    \
            --enable-mpms-shared=all                          \
            --enable-suexec=shared                            \
            --with-apr=/usr/bin/apr-1-config                  \
            --with-apr-util=/usr/bin/apu-1-config             \
            --with-suexec-bin=/usr/lib/httpd/suexec           \
            --with-suexec-caller=apache                       \
            --with-suexec-docroot=/srv/www                    \
            --with-suexec-logfile=/var/log/httpd/suexec.log   \
            --with-suexec-uidmin=100                          \
            --with-suexec-userdir=public_html'
chroot_check $? "configure"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install  &&
mv -v /usr/sbin/suexec /usr/lib/httpd/suexec &&
chgrp apache           /usr/lib/httpd/suexec &&
chmod 4754             /usr/lib/httpd/suexec &&
chown -v -R apache:apache /srv/www
chroot_check $? "make install"

install -m644 /opt/physix/build-scripts/05-services/configs/httpd/httpd.service   /lib/systemd/system/httpd.service 
chroot_check $? "Install /lib/systemd/system/httpd.service"

install -m644 /opt/physix/build-scripts/05-services/configs/httpd/httpd.conf   /etc/httpd.conf
chroot_check $? "Install /etc/httpd.conf"


