#!/bin/bash
source /physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

sed -i '/skipping/d' util/packer.c &&

su physix -c './configure --prefix=/usr    \
            --disable-static \
            --with-default-dict=/lib/cracklib/pw_dict'
chroot_check $? "cracklib : configure"

su physix -c 'make'
chroot_check $? "cracklib : make"

make install                      &&
mv -v /usr/lib/libcrack.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libcrack.so) /usr/lib/libcrack.so
chroot_check $? "cracklib : make install"

install -v -m644 -D    ../cracklib-words-2.9.7.bz2 \
                         /usr/share/dict/cracklib-words.bz2    &&

bunzip2 -v               /usr/share/dict/cracklib-words.bz2    &&
ln -v -sf cracklib-words /usr/share/dict/words                 &&
echo $(hostname) >>      /usr/share/dict/cracklib-extra-words  &&
install -v -m755 -d      /lib/cracklib                         &&
chroot_check $? "cracklib : install docs"

create-cracklib-dict     /usr/share/dict/cracklib-words \
                         /usr/share/dict/cracklib-extra-words
chroot_check $? "cracklib : create cracklib dict"

