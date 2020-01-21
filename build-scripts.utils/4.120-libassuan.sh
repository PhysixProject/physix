#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

./configure --prefix=/usr
chroot_check $? "libassuan : configure"

make                      &&
make -C doc html                                                       &&
makeinfo --html --no-split -o doc/assuan_nochunks.html doc/assuan.texi &&
makeinfo --plaintext       -o doc/assuan.txt           doc/assuan.texi
chroot_check $? "libassuan : make"

make install &&
install -v -dm755   /usr/share/doc/libassuan-2.5.3/html &&
install -v -m644 doc/assuan.html/* \
                    /usr/share/doc/libassuan-2.5.3/html &&
install -v -m644 doc/assuan_nochunks.html \
                    /usr/share/doc/libassuan-2.5.3      &&
install -v -m644 doc/assuan.{txt,texi} \
                    /usr/share/doc/libassuan-2.5.3
chroot_check $? "libassuan : make install"

