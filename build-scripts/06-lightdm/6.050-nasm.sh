#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

# Disabling the install of the documentation because  
# nasm-xdoc was not archvied correctly. If the tarball is called 
# nasm-2.14.02-xdoc, then so should the directory within in it. 
# Instead it has the same dir name as the nasm source and overwrites it
# when placed in the same directory.

#su physix -c 'tar -xf ../nasm-2.14.02-xdoc.tar.xz --strip-components=1'
#su physix -c 'cp -r ../nasm-2.14.02/doc .'
#chroot_check $? "tar nasm docs"

su physix -c './configure --prefix=/usr'
chroot_check $? "configure"

su physix -c 'make'
chroot_check $? "make"

make install
chroot_check $? "make install"

#install -m755 -d         /usr/share/doc/nasm-2.14.02/html  &&
#cp -v doc/html/*.html    /usr/share/doc/nasm-2.14.02/html  &&
#cp -v doc/*.{txt,ps,pdf} /usr/share/doc/nasm-2.14.02
#chroot_check $? "make install"

