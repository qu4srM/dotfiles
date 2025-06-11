#!/bin/bash

# Usage:
# ./volume.sh up
# ./volume.sh down
# ./volume.sh toggle



get_percentage() {
    amixer get Master | grep '%' | awk '{print $5}' | grep -o '[0-9]\+%'
}

get_volume() {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

is_mute() {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep -q off
}

case "$1" in
    up)
        amixer set Master on > /dev/null
        amixer sset Master 5%+ > /dev/null
        ;;
    down)
        amixer set Master on > /dev/null
        amixer sset Master 5%- > /dev/null
        ;;
    toggle)
        amixer set Master toggle > /dev/null
        ;;
    *)
        exec_hide
        ;;
esac
