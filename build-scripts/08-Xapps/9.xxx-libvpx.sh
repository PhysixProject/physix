#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c "sed -i 's/cp -p/cp/' build/make/Makefile"
chroot_check $? "sed fix"

[ ! -e build ] || rm -r build
su physix -c 'mkdir build'
cd build

su physix -c '../configure --prefix=/usr \
              --enable-shared \
              --disable-static'
chroot_check $? "configure"

su physix -c 'make'
chroot_check $? "make"

make install &&
install -v -m644 doc/Vorbis* /usr/share/doc/libvorbis-1.3.6
chroot_check $? "make install"

