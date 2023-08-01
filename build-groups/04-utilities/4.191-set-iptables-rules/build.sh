#!/bin/bash
source include.sh || exit 1

prep() {
	return 0
}

config() {
	return 0
}

build() {
	return 0
}

build_install() {
	iptables -A INPUT -p icmp -s 192.168.1.0/24  --icmp-type echo-request -j ACCEPT &&
	iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
	chroot_check $? "iptables : DROP incoming ping packets from outside network."

	iptables -A INPUT  -p tcp -s 192.168.1.0/24 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
	chroot_check $? "iptables : Allow SSH only within current network"

	install -v -dm755 /etc/iptables &&
	iptables-save > /etc/iptables/iptables.v4
	chroot_check $? "iptables saved"

	#FIXME
	install -v -dm744 /etc/cron.hourly/ && 
	install -v -m744 /opt/admin/physix/build-groups/04-utils/4.191-set-iptables-rules/restore-iptables /etc/cron.hourly/restore-iptables
	chroot_check $? "iptables: install /etc/cron.hourly/restore-iptables"
}

[ $1 == 'prep' ]   && prep   && exit $?
[ $1 == 'config' ] && config && exit $?
[ $1 == 'build' ]  && build  && exit $?
[ $1 == 'build_install' ] && build_install && exit $?

