#!/usr/bin/env bash

set -euo pipefail

###################################
# Colors
###################################

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

###################################
# Paths
###################################

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup"
CONFIG_DIR="$HOME/.config"

DEPENDENCIES_FILE="$REPO_DIR/dependencies.txt"
AUR_FILE="$REPO_DIR/aur_dependencies.txt"

###################################
# Logging
###################################

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

###################################
# Progress (for QML installer)
###################################

progress() {
    echo "PROGRESS:$1"
}

###################################
# Detect package manager
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

    log "Detected package manager: $PKG_MANAGER"
}

###################################
# Install official dependencies
###################################

install_dependencies() {

    if [ ! -f "$DEPENDENCIES_FILE" ]; then
        warn "dependencies.txt not found"
        return
    fi

    deps=$(grep -v '^#' "$DEPENDENCIES_FILE" | tr '\n' ' ')

    log "Installing official dependencies"

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
            error "Unsupported package manager"
            exit 1
        ;;
    esac

    success "Dependencies installed"
}

###################################
# Install AUR dependencies
###################################

install_aur() {

    [ "$PKG_MANAGER" != "pacman" ] && return

    if [ ! -f "$AUR_FILE" ]; then
        warn "aur_dependencies.txt not found"
        return
    fi

    if ! command -v yay >/dev/null; then

        log "Installing yay (AUR helper)"

        sudo pacman -S --needed --noconfirm git base-devel

        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
    fi

    aurdeps=$(grep -v '^#' "$AUR_FILE" | tr '\n' ' ')

    log "Installing AUR packages"

    yay -S --needed --noconfirm $aurdeps

    success "AUR packages installed"
}

###################################
# Backup existing configs
###################################

backup_configs() {

    log "Creating configuration backup"

    mkdir -p "$BACKUP_DIR"

    for dir in ags kitty bin rofi wlogout swaylock cava fastfetch waybar hypr quickshell; do

        if [ -d "$CONFIG_DIR/$dir" ]; then

            cp -rfp "$CONFIG_DIR/$dir" "$BACKUP_DIR/"
            success "Backup: $dir"

        else

            warn "Skipped: $dir"

        fi

    done
}

###################################
# Install ZSH configuration
###################################

install_zsh() {

    log "Installing ZSH configuration"

    if [ -d "$REPO_DIR/home/powerlevel10k" ]; then
        cp -rf "$REPO_DIR/home/powerlevel10k" "$HOME/"
    fi

    if [ -f "$REPO_DIR/home/.zshrc" ]; then
        cp -f "$REPO_DIR/home/.zshrc" "$HOME/"
    fi

    if [ -f "$REPO_DIR/home/.p10k.zsh" ]; then
        cp -f "$REPO_DIR/home/.p10k.zsh" "$HOME/"
    fi

    success "ZSH configured"
}

###################################
# Script permissions
###################################

fix_permissions() {

    log "Fixing script permissions"

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
            success "Permissions fixed: $dir"

        fi

    done
}

###################################
# Install configs
###################################

install_configs() {

    log "Installing dotfiles"

    if [ -d "$REPO_DIR/config" ]; then

        mkdir -p "$CONFIG_DIR"

        cp -rfn "$REPO_DIR/config/"* "$CONFIG_DIR/"

        success "Configs installed"

    else

        error "Config directory not found"
        exit 1

    fi
}

###################################
# Main installer
###################################

main() {

    progress 5
    log "Starting installation"

    progress 10
    detect_package_manager

    progress 20
    install_dependencies

    progress 35
    install_aur

    progress 50
    backup_configs

    progress 65
    install_zsh

    progress 80
    fix_permissions

    progress 90
    install_configs

    progress 100

    success "Installation completed!"
    log "Backup saved at: $BACKUP_DIR"
    log "Restart Hyprland to apply changes"

    echo "DONE"
}

main