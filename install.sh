#!/usr/bin/env bash

set -e

# Directorio del repositorio (donde está el script)
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

# Copiar solo los directorios que existen
for dir in ags kitty bin rofi wlogout swaylock cava fastfetch waybar hypr; do
  if [ -d "$CONFIG_DIR/$dir" ]; then
    cp -rfp "$CONFIG_DIR/$dir" "$BACKUP_DIR/"
    echo "✅ Respaldo de $CONFIG_DIR/$dir completado."
  else
    echo "⚠️ Carpeta no encontrada: $CONFIG_DIR/$dir (omitida)"
  fi
done

echo "📦 Instalando powerlevel10k y zsh desde $REPO_DIR → $HOME"
echo "--------------------------------------------------------"

# Verificar si 'powerlevel10k' es un directorio y copiarlo
if [ -d "$REPO_DIR/home/powerlevel10k" ]; then
  cp -rf "$REPO_DIR/home/powerlevel10k" "$HOME/"
  echo "✅ Instalado powerlevel10k."
else
  echo "⚠️ No se encontró el directorio powerlevel10k en el repositorio (omitido)."
fi

# Verificar si los archivos .zshrc y .p10k.zsh existen en 'home'
if [ -f "$REPO_DIR/home/.zshrc" ]; then
  cp -f "$REPO_DIR/home/.zshrc" "$HOME/"
  echo "✅ Instalado .zshrc."
else
  echo "⚠️ No se encontró .zshrc en el repositorio (omitido)."
fi

if [ -f "$REPO_DIR/home/.p10k.zsh" ]; then
  cp -f "$REPO_DIR/home/.p10k.zsh" "$HOME/"
  echo "✅ Instalado .p10k.zsh."
else
  echo "⚠️ No se encontró .p10k.zsh en el repositorio (omitido)."
fi

echo "🔑 Asignando permisos de ejecución a scripts..."
cd "$REPO_DIR"  # Asegurarse de estar en la raíz del repositorio
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

# Intentar cambiar a 'config', pero verificar si existe
if [ -d "$REPO_DIR/config" ]; then
  echo "📥 Instalando configuraciones en $CONFIG_DIR"
  echo "--------------------------------------------------------"
  cd "$REPO_DIR/config"  # Cambiar al directorio 'config'
  mkdir -p $CONFIG_DIR/{ags,kitty,bin,hypr,rofi,fastfetch,wlogout,swaylock,cava,waybar}
  cp -rfp * $CONFIG_DIR/
else
  echo "⚠️ No se encontró el directorio 'config' en el repositorio. Omite la instalación de configuraciones."
fi

echo "🎉 ¡Instalación completada con éxito!"
echo "📁 Dotfiles copiados y configuraciones aplicadas."
echo "🔐 Scripts marcados como ejecutables donde fue necesario."
echo "🗂️ Archivos originales respaldados en: $BACKUP_DIR"
echo "💡 Si usas una nueva terminal, reiníciala para aplicar los cambios."
echo "✨ Gracias por usar los dotfiles de Qu4s4rM ✨"
echo "--------------------------------------------------------"
