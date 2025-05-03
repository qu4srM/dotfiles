#!/bin/bash

MODE_FILE="$HOME/.config/ags/scss/theme_mode"
THEME_SCRIPT="$HOME/.config/ags/scripts/change_theme.sh"
RELOAD_SCRIPT="$HOME/.config/ags/launch.sh launch"

if [ ! -f "$MODE_FILE" ]; then
    echo "light" > "$MODE_FILE"
fi

CURRENT_MODE=$(cat "$MODE_FILE")

if [ "$CURRENT_MODE" = "light" ]; then
    echo "dark" > "$MODE_FILE"
    NEW_MODE="dark"
else
    echo "light" > "$MODE_FILE"
    NEW_MODE="light"
fi

echo "Cambiado a modo $NEW_MODE"

# Ejecutar el script que aplica el tema
bash "$THEME_SCRIPT"
sleep 1
bash -c "$RELOAD_SCRIPT"
