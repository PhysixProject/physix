#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/$1 || exit 1

python3 setup.py build
chroot_check $? "python3 setup.py build"

python3 setup.py install --optimize=1
chroot_check $? "python3 setup.py install --optimize=1"


