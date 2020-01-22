#!/bin/bash
source /physix/include.sh || exit 1
source /physix/build.conf || exit 1
cd $SOURCE_DIR/$1 || exit 1

su physix -c './configure --prefix=/usr --disable-static \
            --with-securedir=/lib/security \
            --with-python-binary=python3'
chroot_check $? "libpwquality : configure"

su physix -c 'make'
chroot_check $? "libpwquality : make"

make install
chroot_check $? "libpwquality : make install"

mv /etc/pam.d/system-password{,.orig} &&
cat > /etc/pam.d/system-password << "EOF"
# Begin /etc/pam.d/system-password

# check new passwords for strength (man pam_pwquality)
password  required    pam_pwquality.so   authtok_type=UNIX retry=1 difok=1 \
                                         minlen=8 dcredit=0 ucredit=0 \
                                         lcredit=0 ocredit=0 minclass=1 \
                                         maxrepeat=0 maxsequence=0 \
                                         maxclassrepeat=0 geoscheck=0 \
                                         dictcheck=1 usercheck=1 \
                                         enforcing=1 badwords="" \
                                         dictpath=/lib/cracklib/pw_dict
# use sha512 hash for encryption, use shadow, and use the
# authentication token (chosen password) set by pam_pwquality
# above (or any previous modules)
password  required    pam_unix.so        sha512 shadow use_authtok

# End /etc/pam.d/system-password
EOF
chroot_check $? "libpwquality : /etc/pam.d/system-password written"

