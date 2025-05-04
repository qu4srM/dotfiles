#!/bin/bash

# Obtener el estado de Wi-Fi
status=$(nmcli radio wifi)

# Obtener el estado de la conexión Wi-Fi
wifi_state=$(nmcli dev status | grep 'wifi' | awk '{print $3}')

# Obtener la intensidad de la señal Wi-Fi
wifi_signal=$(nmcli -t -f active,signal dev wifi | grep '^yes' | cut -d ':' -f 2)

# Función para activar o desactivar Wi-Fi
toggle_wifi() {
    if [ "$status" = "enabled" ]; then
        nmcli radio wifi off
    elif [ "$status" = "disabled" ]; then
        nmcli radio wifi on
    fi
}

# Función para cambiar entre estado activo y desconectado
switch_wifi() {
    case "$status" in
        "enabled") echo "switch-active" ;;
        "disabled") echo "switch-none" ;;
    esac
}

# Obtener lista de redes Wi-Fi disponibles
get_list_wifi() {
    nmcli -t -f ssid dev wifi
}

# Obtener el nombre de la red Wi-Fi conectada
get_name() {
    case "$wifi_state" in
        "connected") nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d ':' -f 2 ;;
        "disconnected") echo "Disconnected" ;;
    esac
}

# Obtener el ícono correspondiente al nivel de señal Wi-Fi
get_icon() {
    # icons of papirus comments #
    if [ "$wifi_state" = "no" ]; then
        # echo "network-wireless-offline-symbolic"
        echo "wifi-none-symbolic"
    else
        if [ "$wifi_signal" -le 25 ]; then
            #echo "network-wireless-signal-none-symbolic"
            echo "wifi-level-min-symbolic"
        elif [ "$wifi_signal" -le 50 ]; then
            #echo "network-wireless-signal-weak-symbolic"
            echo "wifi-level-2-symbolic"
        elif [ "$wifi_signal" -le 75 ]; then
            #echo "network-wireless-signal-ok-symbolic"
            echo "wifi-level-3-symbolic"
        #elif [ "$wifi_signal" -le 80 ]; then
            #echo "network-wireless-signal-good-symbolic"
        else
            #echo "network-wireless-signal-excellent-symbolic"
            echo "wifi-level-max-symbolic"
        fi
    fi
}

# Mostrar el estado del Wi-Fi (On o Off)
get_status() {
    case "$status" in
        "enabled") echo "On" ;;
        "disabled") echo "Off" ;;
    esac
}

# Mostrar el estado de la conexión (Conectado o Desconectado)
get_network_status() {
    case "$status" in
        "enabled") echo "Connected" ;;
        "disabled") echo "Disconnected" ;;
    esac
}

# Actualizar lista de redes Wi-Fi en formato JSON
list_update() {
    {
    echo "export var networks = ["
    nmcli -t -f active,bssid,ssid,signal dev wifi | grep "^no" | head -n 6 | \
    awk -F':' '
        BEGIN { id = 1 }
        {
        bssid = $2 ":" $3 ":" $4 ":" $5 ":" $6 ":" $7
        gsub(/\\:/, ":", bssid)  # <- aquí quitamos los backslashes
        ssid = $8
        for (i=9; i<NF; i++) ssid = ssid ":" $i
        signal = $NF
        gsub(/"/, "\\\"", ssid)
        print "  {\"id\":" id ",\"name\":\"" ssid "\",\"bssid\":\"" bssid "\",\"signal\":" signal "},"
        id++
        }
    ' | sed '$ s/,$//'
    echo "]"
    } > ~/.config/ags/components/wificonf/networks.js
}

# Ejecutar la función según el parámetro pasado
case $1 in
    getname) get_name ;;
    geticon) get_icon ;;
    getlistwifi) get_list_wifi ;;
    switchwifi) switch_wifi ;;
    power) toggle_wifi ;;
    status) get_status ;;
    networkstatus) get_network_status ;;
    listupdate) list_update ;;
    *)
        echo "Uso: $0 {getname|geticon|getlistwifi|switchwifi|power|status|networkstatus|listupdate}"
        exit 1
        ;;
esac
