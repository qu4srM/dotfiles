#!/usr/bin/env bash

# Obtener volumen actual
get_volume() {
    amixer get Master | awk -F'[][]' '/%/ { print $2; exit }'
}

# Obtener volumen como decimal (para el slider de AGS)
get_volume_normalized() {
    local volume
    volume=$(get_volume | tr -d '%')
    echo "scale=2; $volume / 100" | bc
}

# Obtener volumen del micrófono
get_capture() {
    amixer get Capture | awk -F'[][]' '/%/ { print $2; exit }'
}

# Obtener volumen del micrófono como decimal
get_capture_normalized() {
    local capture
    capture=$(get_capture | tr -d '%')
    echo "scale=2; $capture / 100" | bc
}

# Manejador principal
case "$1" in
    getvolume)
        get_volume
        ;;
    getsumvolume)
        get_volume_normalized
        ;;
    getcapture)
        get_capture
        ;;
    getsumcapture)
        get_capture_normalized
        ;;
    getuptime)
        uptime_seconds=$(awk '{print $1}' /proc/uptime)
        uptime_minutes=$(echo "$uptime_seconds / 60" | bc)
        echo "$uptime_minutes minutos"
    ;;
    *)
        echo "Uso: $0 {getvolume|getsumvolume|getcapture|getsumcapture}"
        exit 1
        ;;
esac
