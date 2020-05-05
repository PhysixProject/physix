#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies
source /opt/physix/include.sh || exit 1
source /opt/physix/physix.conf || exit 1

IFACE=`ip link | grep 'state UP' | awk -F: '{print $2}' | tr -d '[:space:]'`
MAC=`cat /sys/class/net/$IFACE/address`
TYPE=`cat /sys/class/net/$IFACE/type`
ID=`cat /sys/class/net/$IFACE/dev_id`


# SETUP /etc/systemd/network/10-eth-static.network
install -v -m644 /opt/physix/build-scripts/03-base-config/configs/etc_eth-static.network.cfg  /etc/systemd/network/10-eth-static.network
SED_CMD='s/INTERFACE_MARKER/'$IFACE'/g'
sed -i $SED_CMD /etc/systemd/network/10-eth-static.network
chroot_check $? "Wrtie etc_eth-static.network.cfg"

SED_CMD='s/CONF_IP_ADDRESS_MARKER/'$CONF_IP_ADDRESS'/g'
sed -i $SED_CMD /etc/systemd/network/10-eth-static.network
chroot_check $? "Set IP Address: $CONF_IP_ADDRESS"

SED_CMD='s/CONF_DEFAULT_ROUTE_MARKER/'$CONF_DEFAULT_ROUTE'/g'
sed -i $SED_CMD /etc/systemd/network/10-eth-static.network
chroot_check $? "Set Default Route: $CONF_DEFAULT_ROUTE"

SED_CMD='s/CONF_NAMESERVER_MARKER/'$CONF_NAMESERVER'/g'
sed -i $SED_CMD /etc/systemd/network/10-eth-static.network
chroot_check $? "Set Default Route: $CONF_DEFAULT_ROUTE"

SED_CMD='s/CONF_DOMAIN_MARKER/'$CONF_DOMAIN'/g'
sed -i $SED_CMD /etc/systemd/network/10-eth-static.network
chroot_check $? "Set DOMAIN: $CONF_DOMAIN"


# SETUP /etc/systemd/network/10-ether0.link
report "Creating /etc/systemd/network/10-ether0.link"
install -v -m644 /opt/physix/build-scripts/03-base-config/configs/etc_network_10-ether0.link.cfg  /etc/systemd/network/10-ether0.link
chroot_check $? "system config : network :  cp -v /physix/config_scripts/etc_network_10-ether0.linkf.cfg /etc/systemd/network/10-ether0.link"

SED_CMD='s/MAC_ADDRESS_MARKER/'$MAC'/g'
sed -i $SED_CMD /etc/systemd/network/10-ether0.link
chroot_check $? "Set MAC ADDRESS: $MAC"

SED_CMD='s/INTERFACE_MARKER/'$IFACE'/g'
sed -i $SED_CMD /etc/systemd/network/10-ether0.link
chroot_check $? "Set IFACE: $IFACE"
install -v -m644 /opt/physix/build-scripts/03-base-config/configs/etc_hosts.cfg  /etc/hosts
chroot_check $? "system config : network : wrote /etc/hosts"

# SETUP UDEV
report "Creating /etc/udev/rules.d/70-persistent-net.rules"
RULES='/etc/udev/rules.d/70-persistent-net.rules'
if [ -r $RULES ] ; then
        rm $RULES
        touch /etc/udev/rules.d/70-persistent-net.rules
fi

for IFACE in `ls /sys/class/net` ; do
        MAC=`cat /sys/class/net/$IFACE/address`
        TYPE=`cat /sys/class/net/$IFACE/type`
        ID=`cat /sys/class/net/$IFACE/dev_id`
	ENTRY="SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$MAC\", ATTR{dev_id}==\"$ID\", ATTR{type}==\"$TYPE\", NAME=\"$IFACE\""
        echo $ENTRY >> $RULES
	chroot_check $? "$ENTRY"
done

install -v -m644 /opt/physix/build-scripts/03-base-config/configs/motd  /etc/motd
chroot_check $? "cp -v /physix/build-scripts.config/configs/motd /etc/motd"

