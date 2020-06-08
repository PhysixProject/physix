#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /opt/admin/physix/physix.conf || exit 1

GUSER=`echo $CONF_GEN_USER | cut -d'=' -f2`

sed -e '/^pre-install:/{N;s@;@ -a -r $(sudoersdir)/sudoers;@}' \
    -i plugins/sudoers/Makefile.in

su physix -c './configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/sudo-1.8.29 \
            --with-passprompt="[sudo] password for %p: "'
chroot_check $? "sudo : configure"

su physix -c 'make'
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

