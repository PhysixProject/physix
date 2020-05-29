#!/bin/bash
source /opt/physix/include.sh || exit 1


python2 setup.py build &&
python3 setup.py build
chroot_check $? "setup.p"

python2 setup.py install --optimize=1   &&
python2 setup.py install_pycairo_header &&
python2 setup.py install_pkgconfig      &&
python3 setup.py install --optimize=1   &&
python3 setup.py install_pycairo_header &&
python3 setup.py install_pkgconfig
chroot_check $? "install"

