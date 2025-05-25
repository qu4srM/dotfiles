#!/bin/bash

# Ruta al archivo que guarda el modo actual
MODE_FILE="$HOME/.config/ags/scss/theme_mode"

# Leer el modo actual
MODE=$(cat "$MODE_FILE")

# Ruta al archivo CSS donde cambiarán los valores
SCSS_FILE="$HOME/.config/ags/scss/colors.scss"

# Limpiar el archivo SCSS antes de escribir nuevos valores
> "$SCSS_FILE"

# Colores predefinidos para el modo oscuro
DARK_BG="#131412"
DARK_BG_BLUR="#18111abb"
DARK_BG_WIDGETS="#1f272e"
DARK_FG_WIDGETS="#3b3d38"
DARK_BTN_WORK="#505050"
DARK_BG_PANELS="#1B1C1A"
DARK_FG_PANELS="#262724"
DARK_TEXT_COLOR="#D1D1D1"  # Color de texto en modo oscuro

# Colores predefinidos para el modo claro
LIGHT_BG="#d8d6d6"
LIGHT_BG_BLUR="#f0f0f0bb"
LIGHT_BG_WIDGETS="#ffffff"
LIGHT_FG_WIDGETS="#cccccc"
LIGHT_BTN_WORK="#707070"
LIGHT_BG_PANELS="#ffffff"
LIGHT_FG_PANELS="#bdbdbd"
LIGHT_TEXT_COLOR="#333333"  # Color de texto en modo claro

# Generación del archivo SCSS según el modo
if [ "$MODE" = "dark" ]; then
    echo "Modo oscuro seleccionado."

    # Escribir las variables SCSS para el modo oscuro
    cat <<EOF > "$SCSS_FILE"
// Dark Mode Colors
\$bg: $DARK_BG;
\$bg-blur: $DARK_BG_BLUR;
\$bg-widgets: $DARK_BG_WIDGETS;
\$fg-widgets: $DARK_FG_WIDGETS;
\$color-btn-work: $DARK_BTN_WORK;
\$bg-panels: $DARK_BG_PANELS;
\$fg-panels: $DARK_FG_PANELS;
\$text-color: $DARK_TEXT_COLOR; 
EOF

elif [ "$MODE" = "light" ]; then
    echo "Modo claro seleccionado."

    # Escribir las variables SCSS para el modo claro
    cat <<EOF > "$SCSS_FILE"
// Light Mode Colors
\$bg: $LIGHT_BG;
\$bg-blur: $LIGHT_BG_BLUR;
\$bg-widgets: $LIGHT_BG_WIDGETS;
\$fg-widgets: $LIGHT_FG_WIDGETS;
\$color-btn-work: $LIGHT_BTN_WORK;
\$bg-panels: $LIGHT_BG_PANELS;
\$fg-panels: $LIGHT_FG_PANELS;
\$text-color: $LIGHT_TEXT_COLOR;
EOF
fi