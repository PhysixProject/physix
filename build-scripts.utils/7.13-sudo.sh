#!/bin/bash

source /physix/include.sh
                     
cd /sources
PKG=$1
stripit $PKG
SRCD=$STRIPPED

cd /sources
unpack $PKG
cd /sources/$SRCD

GUSER=`cat /physix/build.conf | grep GEN_USER | cut -d'=' -f2`

./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.8.27 \
            --with-passprompt="[sudo] password for %p: " 
chroot_check $? "sudo : configure"

make
chroot_check $? "sudo : make"

make install &&
ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0
chroot_check $? "sudo : make install"

cat > /etc/sudoers.d/sudo << "EOF"
Defaults secure_path="/usr/bin:/bin:/usr/sbin:/sbin"
%wheel ALL=(ALL) ALL
EOF
chroot_check $? "sudo : /etc/sudoers.d/sudo written"

usermod -a -G wheel $GUSER
chroot_check $? "sudo : Added $GUSER to wheel group"

rm -rf /sources/$SRCD

