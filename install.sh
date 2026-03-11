#!/usr/bin/env bash

set -e

###################################
# Paths
###################################

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BACKUP_DIR="$HOME/dotfiles_backup"
CONFIG_DIR="$HOME/.config"

DEPENDENCIES_FILE="$SCRIPT_DIR/dependencies.txt"
AUR_FILE="$SCRIPT_DIR/aur_dependencies.txt"

echo "LOG:Repositorio detectado"
echo "LOG:$REPO_DIR"

mkdir -p "$BACKUP_DIR"
mkdir -p "$CONFIG_DIR"

###################################
# Detectar gestor de paquetes
###################################

detect_package_manager() {

    if command -v pacman >/dev/null; then
        PKG_MANAGER="pacman"
    elif command -v apt >/dev/null; then
        PKG_MANAGER="apt"
    elif command -v dnf >/dev/null; then
        PKG_MANAGER="dnf"
    else
        PKG_MANAGER="unknown"
    fi

    echo "LOG:Gestor detectado -> $PKG_MANAGER"
}

###################################
# Instalar dependencias oficiales
###################################

install_dependencies() {

    if [ ! -f "$DEPENDENCIES_FILE" ]; then
        echo "LOG:dependencies.txt no encontrado"
        return
    fi

    deps=$(grep -v '^#' "$DEPENDENCIES_FILE" | tr '\n' ' ')

    echo "LOG:Instalando dependencias oficiales"

    case "$PKG_MANAGER" in

        pacman)
            sudo pacman -Sy --needed --noconfirm $deps
        ;;

        apt)
            sudo apt update
            sudo apt install -y $deps
        ;;

        dnf)
            sudo dnf install -y $deps
        ;;

        *)
            echo "LOG:Gestor no soportado"
        ;;
    esac
}

###################################
# Instalar AUR
###################################

install_aur() {

    if [ "$PKG_MANAGER" != "pacman" ]; then
        return
    fi

    if [ ! -f "$AUR_FILE" ]; then
        echo "LOG:aur_dependencies.txt no encontrado"
        return
    fi

    if ! command -v yay >/dev/null; then

        echo "LOG:yay no encontrado, instalando..."

        sudo pacman -S --needed git base-devel --noconfirm

        git clone https://aur.archlinux.org/yay.git /tmp/yay

        cd /tmp/yay

        makepkg -si --noconfirm
    fi

    aurdeps=$(grep -v '^#' "$AUR_FILE" | tr '\n' ' ')

    echo "LOG:Instalando paquetes AUR"

    yay -S --needed --noconfirm $aurdeps
}

###################################
# Backup
###################################

echo "PROGRESS:5"
echo "LOG:Creando backup de configuraciones"

for dir in quickshell ags kitty bin rofi wlogout swaylock cava fastfetch waybar hypr; do

  if [ -d "$CONFIG_DIR/$dir" ]; then

    cp -rfp "$CONFIG_DIR/$dir" "$BACKUP_DIR/"

    echo "LOG:Backup $dir"

  else

    echo "LOG:Omitido $dir"

  fi

done

###################################
# Dependencias
###################################

echo "PROGRESS:20"

detect_package_manager
install_dependencies
install_aur

###################################
# ZSH
###################################

echo "PROGRESS:40"
echo "LOG:Instalando configuración ZSH"

if [ -d "$REPO_DIR/home/powerlevel10k" ]; then
  cp -rf "$REPO_DIR/home/powerlevel10k" "$HOME/"
fi

if [ -f "$REPO_DIR/home/.zshrc" ]; then
  cp "$REPO_DIR/home/.zshrc" "$HOME/"
fi

if [ -f "$REPO_DIR/home/.p10k.zsh" ]; then
  cp "$REPO_DIR/home/.p10k.zsh" "$HOME/"
fi

###################################
# Permisos scripts
###################################

echo "PROGRESS:60"
echo "LOG:Asignando permisos a scripts"

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

  full="$REPO_DIR/$dir"

  if [ -d "$full" ]; then

      find "$full" -type f -name "*.sh" -exec chmod +x {} \;

      echo "LOG:Permisos -> $dir"

  fi

done

###################################
# Copiar configuraciones
###################################

echo "PROGRESS:80"
echo "LOG:Instalando configuraciones"

if [ -d "$REPO_DIR/config" ]; then

  mkdir -p $CONFIG_DIR/{quickshell,ags,kitty,bin,hypr,rofi,fastfetch,wlogout,swaylock,cava,waybar}

  cp -rfp "$REPO_DIR/config/"* "$CONFIG_DIR/"

fi

###################################
# Finalizar
###################################

echo "PROGRESS:95"
echo "LOG:Finalizando instalación"

sleep 1

echo "LOG:Backup guardado en $BACKUP_DIR"

echo "PROGRESS:100"
echo "LOG:Instalación completada"

echo "LOG:Reinicia Hyprland para aplicar cambios"

echo "DONE"