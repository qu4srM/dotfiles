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

case $1 in
    getname)
        get_name
        ;;
    geticon)
        get_icon
        ;;
    *)
        echo "Invalid option"
        ;;
esac
