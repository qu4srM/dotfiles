#!/usr/bin/env bash


toggle_output_audio () {
    # Obtener todos los dispositivos de salida (sinks)
    sinks=($(pactl list sinks short | awk '{print $2}'))

    # Verificar que haya al menos dos dispositivos de salida
    if [ ${#sinks[@]} -lt 2 ]; then
        echo "❌ No hay suficientes dispositivos de salida para hacer toggle."
        exit 1
    fi

    # Obtener el dispositivo de salida actual
    current=$(pactl get-default-sink)

    # Toggle entre los dos primeros dispositivos
    if [[ "$current" == "${sinks[0]}" ]]; then
        pactl set-default-sink "${sinks[1]}"
        echo "🔊 Cambiado a: ${sinks[1]}"
    else
        pactl set-default-sink "${sinks[0]}"
        echo "🔊 Cambiado a: ${sinks[0]}"
    fi

}
toggle_microphone () {
    # Obtener solo las fuentes de entrada (input), ignorando monitors
    inputs=($(pactl list sources short | grep input | grep -v monitor | awk '{print $2}'))

    # Si no hay al menos dos, no hacer toggle
    if [ ${#inputs[@]} -lt 2 ]; then
        echo "❌ Solo hay un micrófono disponible: ${inputs[0]}"
        exit 1
    fi

    # Obtener micrófono actual
    current=$(pactl get-default-source)

    # Toggle
    if [[ "$current" == "${inputs[0]}" ]]; then
        pactl set-default-source "${inputs[1]}"
        echo "🔊 Cambiado a: ${inputs[1]}"
    else
        pactl set-default-source "${inputs[0]}"
        echo "🔊 Cambiado a: ${inputs[0]}"
    fi
}

get_brightness () {
    local backlight_dir="/sys/class/backlight/intel_backlight"
    cat "$backlight_dir/brightness"
}

get_brightness_normalized() {
    local backlight_dir="/sys/class/backlight/intel_backlight"
    local brightness max
    brightness=$(cat "$backlight_dir/brightness")
    max=$(cat "$backlight_dir/max_brightness")

    echo "scale=2; $brightness / $max" | bc
}

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
    getbrightness)
        get_brightness_normalized
        ;;
    getsumvolume)
        get_volume_normalized
        ;;
    getsumcapture)
        get_capture_normalized
        ;;
    getuptime)
        uptime_seconds=$(awk '{print $1}' /proc/uptime)
        uptime_minutes=$(echo "$uptime_seconds / 60" | bc)
        echo "$uptime_minutes minutos"
    ;;
    getmicrophone)
        pactl list sources short | grep input | grep -v monitor | awk '{split($2, a, "."); print a[length(a)]}'
    ;;
    togglemicrophone)
        toggle_microphone
    ;;
    getsinks)
        pactl list sinks | grep -E 'Description' | awk -F ' ' '{print $2, $3}'
    ;;
    toggleoutputaudio)
        toggle_output_audio
    ;;

    *)
        echo "Uso: $0 {getvolume|getsumvolume|getcapture|getsumcapture}"
        exit 1
        ;;
esac
