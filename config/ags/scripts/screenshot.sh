#!/usr/bin/env bash

# Ruta de guardado temporal
FILE="/tmp/screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png"

case $1 in
    all)
        grim "$FILE" && wl-copy < "$FILE"
        ;;
    monitor)
        grim "$FILE" && wl-copy < "$FILE"
        ;;
    area)
        grim -g "$(slurp)" "$FILE" && wl-copy < "$FILE"
        ;;
esac

cp "$FILE" ~/Pictures/
