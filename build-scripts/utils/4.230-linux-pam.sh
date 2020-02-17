#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c 'tar -xf ../Linux-PAM-1.3.1-docs.tar.xz --strip-components=1'
chroot_check $? "Linux-PAM : untar doc tarball"

su physix -c "ed -e 's/dummy links/dummy lynx/' \
    -e 's/-no-numbering -no-references/-force-html -nonumbers -stdin/' \
    -i configure"

su physix -c './configure --prefix=/usr                    \
            --sysconfdir=/etc                \
            --libdir=/usr/lib                \
            --enable-securedir=/lib/security \
            --docdir=/usr/share/doc/Linux-PAM-1.3.1'
chroot_check $? "Linux-PAM : configure"

su physix -c 'make'
chroot_check $? "Linux-PAM : make"


install -v -m755 -d /etc/pam.d &&
chroot_check $? "Linux-PAM : install "

cp -v /physix/build-scripts/utils/configs/linux-pam/other.test /etc/pam.d/other
chroot_check $? "Created /etc/pam.d/other for make check"

make check
chroot_check $? "make check"

rm -v /etc/pam.d/other
chroot_check $? "rm /etc/pam.d/other.test"

make install &&
chmod -v 4755 /sbin/unix_chkpwd &&
chroot_check $? "Linux-PAM : make install"

for file in pam pam_misc pamc
do
  mv -v /usr/lib/lib${file}.so.* /lib &&
  ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
  chroot_check $? "Linux-PAM : ln /usr/lib/lib${file}.so"
done


install -vdm755 /etc/pam.d 
chroot_check $? "Create /etc/pam.d"

cp -v /physix/build-scripts/utils/configs/linux-pam/other /etc/pam.d
chroot_check $? "Writing /etc/pam.d/ config files"

#These are the names provided in the book
#cat > /etc/pam.d/system-account << "EOF" &&
#cat > /etc/pam.d/system-auth << "EOF" &&
#cat > /etc/pam.d/system-session << "EOF"
#cat > /etc/pam.d/system-password << "EOF"
#cat > /etc/pam.d/other << "EOF"

