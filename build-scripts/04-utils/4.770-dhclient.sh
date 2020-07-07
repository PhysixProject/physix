#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/physix.conf || exit 1


CONFIGURE=`pwd`/dhc_configure.sh
cat <<EOT >> $CONFIGURE
#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/physix.conf || exit 1

export CFLAGS="$CFLAGS -Wall -fno-strict-aliasing                   \
        -D_PATH_DHCLIENT_SCRIPT='\"/sbin/dhclient-script\"'         \
        -D_PATH_DHCPD_CONF='\"/etc/dhcp/dhcpd.conf\"'               \
        -D_PATH_DHCLIENT_CONF='\"/etc/dhcp/dhclient.conf\"'"        &&
./configure --prefix=/usr                                           \
            --sysconfdir=/etc/dhcp                                  \
            --localstatedir=/var                                    \
            --with-srv-lease-file=/var/lib/dhcpd/dhcpd.leases       \
            --with-srv6-lease-file=/var/lib/dhcpd/dhcpd6.leases     \
            --with-cli-lease-file=/var/lib/dhclient/dhclient.leases \
            --with-cli6-lease-file=/var/lib/dhclient/dhclient6.leases  && make -j1
EOT
chmod +x $CONFIGURE


su physix -c "$CONFIGURE"
chroot_check $? "configure/make"


make -C client install         &&
mv -v /usr/sbin/dhclient /sbin &&
install -v -m755 client/scripts/linux /sbin/dhclient-script
chroot_check $? "make install"

install -v -dm 755 /var/lib/dhclient
chroot_check $? "install -v -dm 755 /var/lib/dhclient"

dhclient enp0s3
chroot_check $? "dhclient test"

install -d -m 755 /etc/default &&
install -d -m 755 /usr/lib/tmpfiles.d &&
install -d -m 755 /lib/systemd/system
chroot_check $? "install dirs"

install -v -m644 /opt/admin/physix/build-scripts/04-utils/configs/dhclient/dhclient@.service  /lib/systemd/system/
chroot_check $? "Install  /lib/systemd/system/dhclient@.service"

systemctl disable systemd-networkd
chroot_check $? "disable systemd-networkd"

systemctl enable dhclient@enp0s3


