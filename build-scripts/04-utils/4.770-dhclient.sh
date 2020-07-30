#!/bin/bash
source /opt/admin/physix/include.sh || exit 1
source /etc/physix.conf || exit 1

prep() {
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
}


config() {
        ./dhc_configure.sh
        chroot_check $? "configure/make"
}

build() {
        make -C client
        chroot_check $? "make "
}

build_install() {

        make -C client install

        mv -v /usr/sbin/dhclient /sbin &&
        install -v -m755 client/scripts/linux /sbin/dhclient-script

        install -v -dm 755 /var/lib/dhclient
        chroot_check $? "install -v -dm 755 /var/lib/dhclient"

        IFACE=`ip link | grep 'state UP' | awk -F: '{print $2}' | tr -d '[:space:]'`
        dhclient $IFACE
        chroot_check $? "dhclient test"

        install -d -m 755 /etc/default &&
        install -d -m 755 /usr/lib/tmpfiles.d &&
        install -d -m 755 /lib/systemd/system
        chroot_check $? "install dirs"

        install -v -m644 /opt/admin/physix/build-scripts/04-utils/configs/dhclient/dhclient.conf  /etc/dhcp
        chroot_check $? "Install /etc/dhcp/dhclient.conf"

        install -v -m644 /opt/admin/physix/build-scripts/04-utils/configs/dhclient/dhclient@.service  /lib/systemd/system/
        chroot_check $? "Install  /lib/systemd/system/dhclient@.service"

        systemctl disable systemd-networkd
        chroot_check $? "disable systemd-networkd"

        systemctl enable dhclient@$IFACE
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

