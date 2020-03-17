#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

grep -q mail /etc/group
if [ $? -ne 0 ] ; then
        groupadd -g 34 mail && chgrp -v mail /var/mail
        chroot_check $? "mutt : groupadd -g 34 mail"
fi

su physix -c 'cp -v doc/manual.txt{,.shipped} &&
            ./configure --prefix=/usr                \
            --sysconfdir=/etc                        \
            --with-docdir=/usr/share/doc/mutt-1.12.1 \
            --with-ssl                               \
            --enable-external-dotlock                \
            --enable-pop                             \
            --enable-imap                            \
            --enable-hcache                          \
            --enable-sidebar'
chroot_check $? "mutt : configure"

su physix -c "make -j$NPROC"
chroot_check $? "mutt : make"

make install &&
test -s doc/manual.txt ||
  install -v -m644 doc/manual.txt.shipped \
  /usr/share/doc/mutt-1.12.1/manual.txt
chroot_check $? "mutt : make install"

