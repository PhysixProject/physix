#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'tar -xf ../nasm-2.14.02-xdoc.tar.xz --strip-components=1'
chroot_check $? "tar nasm docs"

su physix -c './configure --prefix=/usr'
chroot_check $? "configure"

su physix -c 'make'
chroot_check $? "make"

make install
chroot_check $? "make install"

install -m755 -d         /usr/share/doc/nasm-2.14.02/html  &&
cp -v doc/html/*.html    /usr/share/doc/nasm-2.14.02/html  &&
cp -v doc/*.{txt,ps,pdf} /usr/share/doc/nasm-2.14.02
chroot_check $? "make install"

