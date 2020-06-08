#!/bin/bash
source /opt/admin/physix/include.sh || exit 1


su physix -c "sed -e 's#l \(gtk-.*\).sgml#& -o \1#' \
    -i docs/{faq,tutorial}/Makefile.in"
chroot_check $? "sed fix"

su physix -c './configure --prefix=/usr --sysconfdir=/etc'
chroot_check $? "configure"

su physix -c "make -j$NPROC"
chroot_check $? "make"

make install
chroot_check $? "make install"

gtk-query-immodules-2.0 --update-cache
chroot_check $? "gtk-query-immodules-2.0"

