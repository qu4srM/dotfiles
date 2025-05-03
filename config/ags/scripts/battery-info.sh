#!/bin/bash

# Obtener el estado de la batería
battery_info=$(acpi -b)

# Extraer porcentaje de carga y estado
percentage=$(cat /sys/class/power_supply/BAT*/capacity)
state=$(cat /sys/class/power_supply/BAT*/status)

# Función para obtener el porcentaje de la batería
get_percentage() {
    echo "$percentage"
}

# Función para obtener el ícono de la batería según el nivel de carga
get_icon() {
    if [ "$charging_status" = "Charging" ]; then
        if [ "$percentage" -le 10 ]; then
            echo "battery-level-10-charging-symbolic"
        elif [ "$percentage" -le 20 ]; then
            echo "battery-level-20-charging-symbolic"
        elif [ "$percentage" -le 30 ]; then
            echo "battery-level-30-charging-symbolic"
        elif [ "$percentage" -le 40 ]; then
            echo "battery-level-40-charging-symbolic"
        elif [ "$percentage" -le 50 ]; then
            echo "battery-level-50-charging-symbolic"
        elif [ "$percentage" -le 60 ]; then
            echo "battery-level-60-charging-symbolic"
        elif [ "$percentage" -le 70 ]; then
            echo "battery-level-70-charging-symbolic"
        elif [ "$percentage" -le 80 ]; then
            echo "battery-level-80-charging-symbolic"
        elif [ "$percentage" -le 90 ]; then
            echo "battery-level-90-charging-symbolic"
        else
            echo "battery-level-100-charged-symbolic"
        fi
    else
        if [ "$percentage" -le 10 ]; then
            echo "battery-level-10-symbolic"
        elif [ "$percentage" -le 20 ]; then
            echo "battery-level-20-symbolic"
        elif [ "$percentage" -le 30 ]; then
            echo "battery-level-30-symbolic"
        elif [ "$percentage" -le 40 ]; then
            echo "battery-level-40-symbolic"
        elif [ "$percentage" -le 50 ]; then
            echo "battery-level-50-symbolic"
        elif [ "$percentage" -le 60 ]; then
            echo "battery-level-60-symbolic"
        elif [ "$percentage" -le 70 ]; then
            echo "battery-level-70-symbolic"
        elif [ "$percentage" -le 80 ]; then
            echo "battery-level-80-symbolic"
        elif [ "$percentage" -le 90 ]; then
            echo "battery-level-90-symbolic"
        else
            echo "battery-level-100-symbolic"
        fi
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
