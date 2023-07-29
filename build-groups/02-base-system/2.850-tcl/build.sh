#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1


tar -xf ../tcl8.6.10-html.tar.gz --strip-components=1


export SRCDIR=`pwd` &&
cd unix &&
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit) &&
chroot_check $? "configure"


make
chroot_check $? "make"


sed -e "s#$SRCDIR/unix#/usr/lib#" \
    -e "s#$SRCDIR#/usr/include#"  \
    -i tclConfig.sh               &&
sed -e "s#$SRCDIR/unix/pkgs/tdbc1.1.1#/usr/lib/tdbc1.1.1#" \
    -e "s#$SRCDIR/pkgs/tdbc1.1.1/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/tdbc1.1.1/library#/usr/lib/tcl8.6#" \
    -e "s#$SRCDIR/pkgs/tdbc1.1.1#/usr/include#"            \
    -i pkgs/tdbc1.1.1/tdbcConfig.sh                        &&
sed -e "s#$SRCDIR/unix/pkgs/itcl4.2.0#/usr/lib/itcl4.2.0#" \
    -e "s#$SRCDIR/pkgs/itcl4.2.0/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/itcl4.2.0#/usr/include#"            \
    -i pkgs/itcl4.2.0/itclConfig.sh                        &&
unset SRCDIR
chroot_check $? "sed tweak"


make install &&
make install-private-headers &&
ln -v -sf tclsh8.6 /usr/bin/tclsh &&
chmod -v 755 /usr/lib/libtcl8.6.so
chroot_check $? "make install"


mkdir -v -p /usr/share/doc/tcl-8.6.10 &&
cp -v -r  ../html/* /usr/share/doc/tcl-8.6.10
chroot_check $? "Install Documentation"

