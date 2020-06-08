#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

sed '20,$ d' -i trust/trust-extract-compat.in &&
cat >> trust/trust-extract-compat.in << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Generate a new trust store
/usr/sbin/make-ca -f -g
EOF
chroot_check $? "p11kit : "

su physix -c './configure --prefix=/usr  \
              --sysconfdir=/etc          \
              --with-trust-paths=/etc/pki/anchors'
chroot_check $? "p11kit : configure"

su physix -c 'make'
chroot_check $? "p11kit : make"

make install &&
ln -sfv /usr/libexec/p11-kit/trust-extract-compat \
        /usr/bin/update-ca-certificates
chroot_check $? "p11kit : make install"

ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so

