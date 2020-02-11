#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/xc/$1 || exit 3

groupadd -fg 27 polkitd &&
useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 \
        -g polkitd -s /bin/false polkitd

su physix -c "./configure --prefix=/usr \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     \
            --with-os-type=PHYSIX" 
chroot_check $? "configure "

sed -i 's/'-nonet'//' docs/man/Makefile.in  &&
sed -i 's/'-nonet'//' docs/man/Makefile     &&
sed -i 's/'-nonet'//' docs/man/Makefile.am
chroot_check $? "sed rm nonet switch"

su physix -c "make"
chroot_check $? "make"

make install
chroot_check $? "make install"

cp /physix/build-scripts.xorg/configs/polkit/polkit-1  /etc/pam.d/
chroot_check $? "wrote /etc/pam.d/polkit-1"

