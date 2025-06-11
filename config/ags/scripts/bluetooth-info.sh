#!/bin/bash

function get_name {
    state=$(bluetoothctl show | grep "Pairable" | awk '{print $2}')
    if [ "$state" == "yes" ]; then
        bluetoothctl info | grep "Alias" | awk '{print $2}'
    else
        echo "Disconnected"
    fi
}

function get_icon {
    bluetoothctl show | grep -q "Powered: yes"
    if [ $? -ne 0 ]; then
        # Bluetooth apagado
        echo "bluetooth-disabled-symbolic"
    else
        # Bluetooth encendido, verificar si hay algo conectado
        connected_devices=$(bluetoothctl info | grep "Connected: yes")
        if [ -n "$connected_devices" ]; then
            echo "bluetooth-connected-symbolic"
        else
            echo "bluetooth-active-symbolic"
        fi
    fi
}

function configure {
    bluetoothctl << EOF
agent on
default-agent
pairable on
discoverable on
scan on
EOF
    sleep 10
    bluetoothctl scan off
}

function toggle_connection {
    MAC="$1"
    if [ -z "$MAC" ]; then
        echo "Uso: $0 toggle <MAC_ADDRESS>"
        exit 1
    fi

    if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
        echo "Desconectando $MAC..."
        bluetoothctl disconnect "$MAC"
    else
        echo "Conectando $MAC..."
        bluetoothctl connect "$MAC"
    fi
}

case $1 in
    configure)
        configure
        ;;
    getname)
        get_name
        ;;
    geticon)
        get_icon
        ;;
    toggle)
        toggle_connection "$2"
        ;;
    *)
        echo "Invalid option"
        ;;
esac
