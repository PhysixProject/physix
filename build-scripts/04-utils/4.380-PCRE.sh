#!/bin/bash
source /opt/physix/include.sh || exit 1

su physix -c './configure --prefix=/usr                     \
            --docdir=/usr/share/doc/pcre-8.43 \
            --enable-unicode-properties       \
            --enable-pcre16                   \
            --enable-pcre32                   \
            --enable-pcregrep-libz            \
            --enable-pcregrep-libbz2          \
            --enable-pcretest-libreadline     \
            --disable-static'
chroot_check $? "PCRE : configure"

su physix -c 'make'
chroot_check $? "PCRE : make"

make install                     &&
mv -v /usr/lib/libpcre.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libpcre.so) /usr/lib/libpcre.so
chroot_check $? "PCRE : make install"

