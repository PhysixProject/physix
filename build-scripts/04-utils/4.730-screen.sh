#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr       \
            --infodir=/usr/share/info         \
            --mandir=/usr/share/man           \
            --with-socket-dir=/run/screen     \
            --with-pty-group=5                \
            --with-sys-screenrc=/etc/screenrc'
chroot_check $? "screen : configure"

su physix -c 'sed -i -e "s%/usr/local/etc/screenrc%/etc/screenrc%" {etc,doc}/*'

su physix -c "make -j$NPROC"
chroot_check $? "screen : make"

make install &&
install -m 644 etc/etcscreenrc /etc/screenrc
chroot_check $? "screen : make install"

