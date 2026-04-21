#!/bin/sh

IFACE=$(/usr/sbin/ifconfig | grep tun0 | awk '{print $1}' | tr -d ':')


get_status () {
	if [ "$IFACE" = "tun0" ]; then
		echo "$(/usr/sbin/ifconfig tun0 | grep "inet " | awk '{print $2}')"
	else
		echo "Disconected"
	fi
}

case $1 in
    status) get_status ;;
esac