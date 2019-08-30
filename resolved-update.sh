#!/usr/bin/env bash

/etc/openvpn/update-systemd-resolved $*
if [ "$6" == "init" ]
then
	echo $1
	systemd-resolve --interface=$1 "--set-domain=~."
fi