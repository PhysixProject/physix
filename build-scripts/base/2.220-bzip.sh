#!/tools/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch
chroot_check $? "system-build : bzip2  : patch"

sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
chroot_check $? "system-build : bzip2  : sed 1"

sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
chroot_check $? "system-build : bzip2 : sed 2"

make -f Makefile-libbz2_so
chroot_check $? "system-build : bzip2 : make f Makefile-libbz2_so"

make clean
chroot_check $? "system-build : bzip2 : make clean"

make -j8
chroot_check $? "system-build : bzip2 : make "

make PREFIX=/usr install
chroot_check $? "system-build : bzip2 : make install"

cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat

