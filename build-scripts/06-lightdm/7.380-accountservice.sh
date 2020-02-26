#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 3


su physix -c "mkdir build"
cd build

su physix -c "meson --prefix=/usr \
              -Dadmin_group=adm   \
              -Dsystemd=true .."
chroot_check $? "meson configure "

#sed -i 's/'-nonet'//' docs/man/Makefile.in  &&
#sed -i 's/'-nonet'//' docs/man/Makefile     &&
#sed -i 's/'-nonet'//' docs/man/Makefile.am
#chroot_check $? "sed rm nonet switch"

su physix -c "ninja"
chroot_check $? "ninja"

ninja install
chroot_check $? "ninja install"

cp /physix/build-scripts/xorg/configs/polkit/40-adm.rules  /etc/polkit-1/rules.d/
chroot_check $? "Write /etc/polkit-1/rules.d/40-adm.rules"

systemctl enable accounts-daemon
chroot_check $? "Enable accounts-daemon"

