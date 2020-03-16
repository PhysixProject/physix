#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 1

#su physix -c 'tar -xf ../libsass-3.6.1.tar.gz' 
su physix -c 'cp -r ../sassc-3.6.1 .'
chroot_check $? 'unpack libsass'

pushd libsass-3.6.1 

su physix -c 'autoreconf -fi'
chroot_check $? 'autoconf'

su physix -c './configure --prefix=/usr --disable-static '
chroot_check $? 'make'

su physix -c 'make'
chroot_check $? 'make'

make install
chroot_check $? 'make install'

popd
	
su physix -c 'autoreconf -fi'
chroot_check $? 'autoconf'

su physix -c './configure --prefix=/usr'
chroot_check $? 'configure'

su physix -c 'make'
chroot_check $? 'make'

make install
chroot_check $? 'make install'

