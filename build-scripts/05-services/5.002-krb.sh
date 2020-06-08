#!/bin/bash
source /opt/admin/physix/include.sh || exit 1

cd src || exit 1
sed -i -e 's@\^u}@^u cols 300}@' tests/dejagnu/config/default.exp     &&
sed -i -e '/eq 0/{N;s/12 //}'    plugins/kdb/db2/libdb2/test/run.test 


su physix -c './configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var/lib \
            --with-system-et         \
            --with-system-ss         \
            --with-system-verto=no   \
            --enable-dns-for-realm'
chroot_check $? "configure"


su physix -c "make -j$NPROC"
chroot_check $? "make"



make install &&
for f in gssapi_krb5 gssrpc k5crypto kadm5clnt kadm5srv \
         kdb5 kdb_ldap krad krb5 krb5support verto ; do

    find /usr/lib -type f -name "lib$f*.so*" -exec chmod -v 755 {} \;    
done          &&

mv -v /usr/lib/libkrb5.so.3*        /lib &&
mv -v /usr/lib/libk5crypto.so.3*    /lib &&
mv -v /usr/lib/libkrb5support.so.0* /lib &&

ln -v -sf ../../lib/libkrb5.so.3.3        /usr/lib/libkrb5.so        &&
ln -v -sf ../../lib/libk5crypto.so.3.1    /usr/lib/libk5crypto.so    &&
ln -v -sf ../../lib/libkrb5support.so.0.1 /usr/lib/libkrb5support.so &&

mv -v /usr/bin/ksu /bin &&
chmod -v 755 /bin/ksu   &&

install -v -dm755 /usr/share/doc/krb5-1.18 &&
cp -vfr ../doc/*  /usr/share/doc/krb5-1.18
chroot_check $? "make install"

cp -v /opt/admin/physix/build-scripts/05-services/configs/krb/krb5.conf /etc/
chroot_check $? "Write krb5.conf"

# /usr/sbin/krb5kdc
# kdb5_util create -r <EXAMPLE.ORG> -s
# kadmin.local
# kadmin.local: add_policy dict-only
# kadmin.local: addprinc -policy dict-only <loginname>
# kadmin.local: addprinc -randkey host/<belgarath.example.org>
# kadmin.local: ktadd host/<belgarath.example.org>
# start deamon
# /usr/sbin/krb5kdc

