#!/usr/bin/env bash
action=$1
shift

if [ "$action" == "up" ]
then
	/etc/openvpn/update-systemd-resolved $*
	ip route | grep "default via .* dev .*" | awk '{print $3 " " $5}' > /tmp/openvpnscript.conf
	sysctl net.ipv6.conf.all.disable_ipv6 | sed -e "s/ //g" > /tmp/openvpnscript.ipv6.conf
	sysctl net.ipv6.conf.all.disable_ipv6=1
	systemd-resolve --interface=$1 "--set-domain=~."
	systemd-resolve --interface=$(cat /tmp/openvpnscript.conf | awk '{print $2}') --set-domain=local
	ip route del default

elif [ "$action" == "down" ]
then
	echo -e "\033[1;37;41m WARNING  WARNING  WARNING  WARNING  WARNING  WARNING  WARNING \033[0m"
	echo -e "\033[1;37m This is the vpn diconnection guard, press [ENTER] if you want to restore internet connectivity without vpn\033[0m"
	echo -e "\033[1;37;41m WARNING  WARNING  WARNING  WARNING  WARNING  WARNING  WARNING \033[0m"
	read dup
	systemd-resolve --interface=$(cat /tmp/openvpnscript.conf | awk '{print $2}') "--set-domain=~."
	ip route add default via $(cat /tmp/openvpnscript.conf | awk '{print $1}')
	sysctl $(cat /tmp/openvpnscript.ipv6.conf)
fi