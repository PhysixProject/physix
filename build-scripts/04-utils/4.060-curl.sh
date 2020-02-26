#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr     \
              --disable-static                \
              --enable-threaded-resolver      \
              --with-ca-path=/etc/ssl/certs'
chroot_check $? "curl : configure"

su physix -c 'make'
chroot_check $? "curl : make"

make install &&
rm -rf docs/examples/.deps &&
find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \) -exec rm {} \; &&
install -v -d -m755 /usr/share/doc/curl-7.65.3 &&
cp -v -R docs/*     /usr/share/doc/curl-7.65.3
chroot_check $? "curl : make install"

