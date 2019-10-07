#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (C) 2019 Travis Davies

source /physix/include.sh

cp -v /physix/config_scripts/etc_network_10-ether0.linkf.cfg /etc/systemd/network/10-ether0.link
chroot_check $? "system config : network :  cp -v /physix/config_scripts/etc_network_10-ether0.linkf.cfg /etc/systemd/network/10-ether0.link"

cp -v /physix/config_scripts/etc_eth-static.network.cfg /etc/systemd/network/10-eth-static.network
chroot_check $? "system config : network : cp -v etc_eth-static.network.cfg /etc/systemd/network/10-eth-static.network"

cp -v /physix/config_scripts/etc_hosts.cfg /etc/hosts
chroot_check $? "system config : network : cp -v etc_eth-static.network.cfg /etc/systemd/network/10-eth-static.network"

#cp -v /physix/etc_resolv.conf /etc/resolv.conf


