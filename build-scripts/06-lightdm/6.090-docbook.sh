#!/bin/bash
source /opt/physix/include.sh || exit 1
source /etc/profile.d/xorg.sh || exit 2
cd $SOURCE_DIR/ || exit 1

# CHEAP HACK FOR NOW
[ ! -e ./docbook ] || rm -rf ./docbook
mkdir ./docbook
chown physix:root ./docbook
cd ./docbook

su physix -c 'cp /usr/src/physix/sources/docbk31.zip .'
chroot_check $? "pkg cp"
su physix -c 'unzip docbk31.zip'
chroot_check $? "unzip"

su physix -c "sed -i -e '/ISO 8879/d' -e 's|DTDDECL "-//OASIS//DTD DocBook V3.1//EN"|SGMLDECL|g' docbook.cat"
su physix -c 'sed'

install -v -d -m755 /usr/share/sgml/docbook/sgml-dtd-3.1 &&
chown -R root:root . &&
install -v docbook.cat /usr/share/sgml/docbook/sgml-dtd-3.1/catalog &&
cp -v -af *.dtd *.mod *.dcl /usr/share/sgml/docbook/sgml-dtd-3.1 &&

install-catalog --add /etc/sgml/sgml-docbook-dtd-3.1.cat \
    /usr/share/sgml/docbook/sgml-dtd-3.1/catalog &&

install-catalog --add /etc/sgml/sgml-docbook-dtd-3.1.cat \
    /etc/sgml/sgml-docbook.cat


