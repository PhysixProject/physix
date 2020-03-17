#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr \
              --disable-static \
              --docdir=/usr/share/doc/speex-1.2.0'
chroot_check $? "configure speex"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install 
chroot_check $? "make install"



cd ../speexdsp-1.2rc3 || exit 1
su physix -c './configure --prefix=/usr \
            --disable-static \
            --docdir=/usr/share/doc/speexdsp-1.2rc3'
chroot_check $? "configure speex dsp"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install
chroot_check $? "make install speex dsp"

