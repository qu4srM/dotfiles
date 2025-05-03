#!/usr/bin/env bash

# Obtener metadata del reproductor (usado varias veces)
metadata=$(playerctl metadata)

# Obtener el estado del reproductor
state=$(playerctl status)

# Directorio de imágenes
folder="$HOME/.config/ags/assets/img"

# Función para obtener el ícono del reproductor
get_icon() {
    app=$(echo "$metadata" | awk '{print $1}' | head -n 1)
    case "$app" in
        "firefox") echo "firefox" ;;
        "spotify") echo "spotify" ;;
        *) echo "unknown" ;;
    esac
}

# Función para obtener el artista actual
get_artist() {
    echo "$metadata" | grep "xesam:artist" | awk '{$1=""; $2=""; print $0}' | sed 's/^[ \t]*//'
}

# Función para obtener el título de la canción actual
get_title() {
    echo "$metadata" | grep "xesam:title" | awk '{$1=""; $2=""; print $0}' | sed 's/^[ \t]*//'
}

# Función para obtener la imagen del álbum
get_image() {
    url=$(echo "$metadata" | grep 'artUrl' | awk '{print $3}')
    curl -s -o "$folder/coverArt.jpg" "$url"
}

convert_time() {
    local microseconds=$1
    local seconds=$((microseconds / 1000000))
    printf "%02d:%02d\n" $((seconds / 60)) $((seconds % 60))
}

# Función para obtener la duración total de la pista (formato mm:ss)
get_length() {
    length=$(echo "$metadata" | grep "mpris:length" | awk '{$1=""; $2=""; print $0}' | sed 's/^[ \t]*//')
    convert_time "$length"
}
get_length_raw() {
    length=$(echo "$metadata" | grep "mpris:length" | awk '{$1=""; $2=""; print $0}' | sed 's/^[ \t]*//')
    echo $((length / 1000000))
}

# Función para obtener la posición actual de reproducción (formato mm:ss)
get_position() {
    position=$(playerctl position)
    micro_pos=$(echo "$position * 1000000" | bc | cut -d'.' -f1)
    convert_time "$micro_pos"
}
get_position_raw() {
    playerctl position | cut -d. -f1
}

# Función para pausar o reproducir la canción
pause_or_play() {
    playerctl play-pause
}
get_icon_play () {
    state=$(playerctl status)
    if [[ $state == "Playing" ]]; then
        echo "media-playback-pause-symbolic"
    else
        echo "media-playback-start-symbolic"
    fi
}

# Función para detener la reproducción
stop() {
    playerctl stop
}

# Función para reproducir la pista anterior
set_previous() {
    playerctl previous
}

# Función para reproducir la pista siguiente
set_next() {
    playerctl next
}
seek_position () {
    new_pos="$2"
    playerctl position "$new_pos"
}

# Ejecutar la función correspondiente al argumento
case $1 in
    geticon) get_icon ;;
    getlength) get_length ;;
    getlengthraw) get_length_raw ;;
    getposition) get_position ;;
    getpositionraw) get_position_raw ;;
    getartist) get_artist ;;
    gettitle) get_title ;;
    getimage) get_image ;;
    playorpause) pause_or_play ;;
    geticonplay) get_icon_play ;;
    previous) set_previous ;;
    next) set_next ;;
    seek) seek_position "$@" ;;
    *)
        echo "Uso: $0 {geticon|getlength|getposition|getartist|gettitle|getimage|playorpause|previous|next}"
        exit 1
        ;;
esac
