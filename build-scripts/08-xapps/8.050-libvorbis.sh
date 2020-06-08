#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr --disable-static'
chroot_check $? "configure"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install &&
install -v -m644 doc/Vorbis* /usr/share/doc/libvorbis-1.3.6
chroot_check $? "make install"

