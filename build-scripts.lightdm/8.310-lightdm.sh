#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

grep -q lightdm /etc/group
if [ $? -ne 0 ] ; then
	groupadd -g 65 lightdm
	chroot_check $? "add group lightdm"
fi

grep -q lightdm /etc/passwd
if [ $? -ne 0 ] ; then
        useradd  -c "Lightdm Daemon" -d /var/lib/lightdm -u 65 -g lightdm -s /bin/false lightdm
	chroot_check $? "add user lightdm"
fi

su physix -c './configure                  \
              --prefix=/usr                \
              --libexecdir=/usr/lib/lightdm \
              --localstatedir=/var          \
              --sbindir=/usr/bin            \
              --sysconfdir=/etc             \
              --disable-static              \
              --disable-tests               \
              --with-greeter-user=lightdm   \
              --with-greeter-session=lightdm-gtk-greeter \
              --docdir=/usr/share/doc/lightdm-1.30.0'
chroot_check $? "configure"

su physix -c 'make'
chroot_check $? "make"

make install                                                  &&
cp tests/src/lightdm-session /usr/bin                         &&
sed -i '1 s/sh/bash --login/' /usr/bin/lightdm-session        &&
rm -rf /etc/init                                              &&
install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm      &&
install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm-data &&
install -v -dm755 -o lightdm -g lightdm /var/cache/lightdm    &&
install -v -dm770 -o lightdm -g lightdm /var/log/lightdm
chroot_check $? "make install"


su physix -c 'tar -xf ../lightdm-gtk-greeter-2.0.6.tar.gz'
cd lightdm-gtk-greeter-2.0.6 

su physix -c './configure                   \
              --prefix=/usr                 \
              --libexecdir=/usr/lib/lightdm \
              --sbindir=/usr/bin            \
              --sysconfdir=/etc             \
              --with-libxklavier            \
              --enable-kill-on-sigterm      \
              --disable-libido              \
              --disable-libindicator        \
              --disable-static              \
              --docdir=/usr/share/doc/lightdm-gtk-greeter-2.0.6'

su physix -c 'make'
chroot_check $? "make"

make install
chroot_check $? "make install"

cp -v /physix/build-scripts.lightdm/configs/lightdm/lightdm.service /lib/systemd/system/
chroot_check $? "setup /lib/systemd/system/"

systemctl enable lightdm
chroot_check $? "enable lightdm"

