#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2


python3 setup.py build
chroot_check $? "python3 setup.py build"

python3 setup.py install --optimize=1
chroot_check $? "python3 setup.py install --optimize=1"

