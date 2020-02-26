#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1


sed -i "s:asoundlib.h:alsa/asoundlib.h:" src/modules/alsa/*.{c,h} &&
sed -i "s:use-case.h:alsa/use-case.h:" configure.ac &&
sed -i "s:use-case.h:alsa/use-case.h:" src/modules/alsa/alsa-ucm.h

su physix -c 'NOCONFIGURE=1 ./bootstrap.sh     &&
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-bluez4     \
            --disable-bluez5     \
            --disable-rpath'
chroot_check $? "configure speex"

su physix -c 'make'
chroot_check $? "make"

make install 
chroot_check $? "make install"

rm -fv /etc/dbus-1/system.d/pulseaudio-system.conf
chroot_check $? "remove the D-Bus configuration file to avoid additionaly system users"

sed -i '/load-module module-console-kit/s/^/#/' /etc/pulse/default.pa
chroot_check $? "remove reference to console kit"

