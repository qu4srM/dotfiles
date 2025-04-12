#!/bin/bash

# Obtener el estado de la batería
battery_info=$(acpi -b)

# Extraer porcentaje de carga y estado
percentage=$(echo "$battery_info" | awk '{print $4}' | cut -d ',' -f 1 | cut -d '%' -f 1)
state=$(echo "$battery_info" | awk '{print $3}' | cut -d ',' -f 1)

# Función para obtener el porcentaje de la batería
get_percentage() {
    echo "$percentage"
}

# Función para obtener el ícono de la batería según el nivel de carga
get_icon() {
    if [ "$percentage" -le 15 ]; then
        echo "battery-discharging"
    elif [ "$percentage" -ge 70 ]; then
        echo "battery-level-max"
    elif [ "$percentage" -gt 30 ] && [ "$percentage" -lt 70 ]; then
        echo "battery-level-medium"
    elif [ "$percentage" -gt 15 ] && [ "$percentage" -lt 30 ]; then
        echo "battery-level-min"
    fi
}

# Función para obtener el estado de la batería (Cargando o descargando)
get_state() {
    if [ "$state" == "Discharging" ]; then
        echo "false"
    elif [ "$state" == "Charging" ]; then
        echo "true"
    fi
}

# Procesar los casos
case $1 in
    getpercentage)
        get_percentage
        ;;
    getsum)
        # Convertir a decimal
        echo "scale=2; $percentage / 100" | bc
        ;;
    geticon)
        get_icon
        ;;
    getstate)
        get_state
        ;;
    *)
        echo "Uso: $0 {getpercentage|getsum|geticon|getstate}"
        exit 1
        ;;
esac
