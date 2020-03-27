#!/bin/bash
source /opt/physix/include.sh || exit 1
cd $SOURCE_DIR/$1 || exit 1

[ grep nobody /etc/passwd ] && [ grep nogroup /etc/group ]
if [ $? -ne 0 ] ; then
	groupadd -g 99 nogroup &&
	useradd -c "Unprivileged Nobody" -d /dev/null -g nogroup \
    		-s /bin/false -u 99 nobody
fi


su physix -c './configure --prefix=/usr  \
              --sysconfdir=/etc          \
              --sbindir=/sbin            \
              --disable-gss'
chroot_check $? "configure"


su physix -c "make -j$NPROC"
chroot_check $? "make"


make install                      &&
mv -v /sbin/start-statd /usr/sbin &&
chmod u+w,go+r /sbin/mount.nfs    &&
chown nobody.nogroup /var/lib/nfs
chroot_check $? "make install"

cat >> /etc/exports << EOF
#/home 192.168.0.0/24(rw,subtree_check,anonuid=99,anongid=99)
EOF
chroot_check $? "Create /etc/exports"

