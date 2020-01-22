#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

tar -xf ../Linux-PAM-1.3.1-docs.tar.xz --strip-components=1
chroot_check $? "Linux-PAM : untar doc tarball"

sed -e 's/dummy links/dummy lynx/'                                     \
    -e 's/-no-numbering -no-references/-force-html -nonumbers -stdin/' \
    -i configure

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

cat > /etc/pam.d/other << "EOF"
auth     required       pam_deny.so
account  required       pam_deny.so
password required       pam_deny.so
session  required       pam_deny.so
EOF
chroot_check $? "Linux-PAM : /etc/pam.d/other written"

make install &&
chmod -v 4755 /sbin/unix_chkpwd &&
chroot_check $? "Linux-PAM : make install"

for file in pam pam_misc pamc
do
  mv -v /usr/lib/lib${file}.so.* /lib &&
  ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
  chroot_check $? "Linux-PAM : ln /usr/lib/lib${file}.so"
done

install -vdm755 /etc/pam.d &&
cat > /etc/pam.d/system-account << "EOF" &&
# Begin /etc/pam.d/system-account

account   required    pam_unix.so

# End /etc/pam.d/system-account
EOF
chroot_check $? "Linux-PAM : /etc/pam.d/system-account written"

cat > /etc/pam.d/system-auth << "EOF" &&
# Begin /etc/pam.d/system-auth

auth      required    pam_unix.so

# End /etc/pam.d/system-auth
EOF
chroot_check $? "Linux-PAM : /etc/pam.d/system-auth "

cat > /etc/pam.d/system-session << "EOF"
# Begin /etc/pam.d/system-session

session   required    pam_unix.so

# End /etc/pam.d/system-session
EOF
chroot_check $? "Linux-PAM : /etc/pam.d/system-session written "

cat > /etc/pam.d/system-password << "EOF"
# Begin /etc/pam.d/system-password

# check new passwords for strength (man pam_cracklib)
password  required    pam_cracklib.so    authtok_type=UNIX retry=1 difok=5 \
                                         minlen=9 dcredit=1 ucredit=1 \
                                         lcredit=1 ocredit=1 minclass=0 \
                                         maxrepeat=0 maxsequence=0 \
                                         maxclassrepeat=0 \
                                         dictpath=/lib/cracklib/pw_dict
# use sha512 hash for encryption, use shadow, and use the
# authentication token (chosen password) set by pam_cracklib
# above (or any previous modules)
password  required    pam_unix.so        sha512 shadow use_authtok

# End /etc/pam.d/system-password
EOF
chroot_check $? "Linux-PAM : /etc/pam.d/system-password written"

cat > /etc/pam.d/system-password << "EOF"
# Begin /etc/pam.d/system-password

# use sha512 hash for encryption, use shadow, and try to use any previously
# defined authentication token (chosen password) set by any prior module
password  required    pam_unix.so       sha512 shadow try_first_pass

# End /etc/pam.d/system-password
EOF
chroot_check $? "Linux-PAM : /etc/pam.d/system-password written"

cat > /etc/pam.d/other << "EOF"
# Begin /etc/pam.d/other

auth        required        pam_warn.so
auth        required        pam_deny.so
account     required        pam_warn.so
account     required        pam_deny.so
password    required        pam_warn.so
password    required        pam_deny.so
session     required        pam_warn.so
session     required        pam_deny.so

# End /etc/pam.d/other
EOF
chroot_check $? "Linux-PAM : /etc/pam.d/other writen"

