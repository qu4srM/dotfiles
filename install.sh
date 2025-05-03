#!/usr/bin/env bash

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup"
CONFIG_DIR="$HOME/.config"


echo "📁 Repositorio: $REPO_DIR"
echo "📦 Backup en: $BACKUP_DIR"
echo "--------------------------------------------------------"

mkdir -p "$BACKUP_DIR"
mkdir -p "$CONFIG_DIR"


echo "📦 Backup de $CONFIG_DIR → $BACKUP_DIR"
echo "--------------------------------------------------------"
cp -r $CONFIG_DIR/ags $CONFIG_DIR/kitty $CONFIG_DIR/bin $CONFIG_DIR/rofi $CONFIG_DIR/wlogout $CONFIG_DIR/swaylock $CONFIG_DIR/cava $CONFIG_DIR/fastfetch $CONFIG_DIR/waybar $CONFIG_DIR/hypr $BACKUP_DIR/

echo "📦 Instalando powerlevel10k y zsh desde $(pwd) → $HOME"
echo "--------------------------------------------------------"
cd home
cp -r .zshrc .p10k.zsh $HOME/

echo "🔑 Asignando permisos de ejecución a scripts..."
cd ..
SCRIPT_DIRS=(
  "config/ags/scripts"
  "config/ags"
  "config/bin"
  "config/hypr"
  "config/rofi/launcher"
  "config/rofi/wall"
  "config/waybar"
  "config/wlogout"
)
for dir in "${SCRIPT_DIRS[@]}"; do
  full_path="$REPO_DIR/$dir"
  if [ -d "$full_path" ]; then
    find "$full_path" -type f -name "*.sh" -exec chmod +x {} \;
    echo "✅ Ejecutables en: $dir"
  else
    echo "⚠️ Carpeta no encontrada: $dir (omitida)"
  fi
done
echo "--------------------------------------------------------"

echo "📥 Instalando configuraciones en $CONFIG_DIR"
echo "--------------------------------------------------------"
cd config
cp -r * $CONFIG_DIR/

echo "🎉 ¡Instalación completada con éxito!"
echo "📁 Dotfiles copiados y configuraciones aplicadas."
echo "🔐 Scripts marcados como ejecutables donde fue necesario."
echo "🗂️ Archivos originales respaldados en: $BACKUP_DIR"
echo "💡 Si usas una nueva terminal, reiníciala para aplicar los cambios."
echo "✨ Gracias por usar los dotfiles de Qu4s4rM ✨"
echo "--------------------------------------------------------"


