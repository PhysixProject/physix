#!/bin/bash
source /opt/admin/physix/include.sh || exit 1


su physix -c 'mkdir ./build'
chroot_check $? "mkdir buiild dir"
cd ./build

su physix -c 'cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=RELEASE  \
      -DENABLE_STATIC=FALSE       \
      -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/libjpeg-turbo-2.0.2 \
      -DCMAKE_INSTALL_DEFAULT_LIBDIR=lib ..'
chroot_check $? "cmake"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install 
chroot_check $? "make install"

