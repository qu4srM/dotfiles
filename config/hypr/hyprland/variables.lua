-- Quickshell config folder
hl.env("qsConfig", "cm")

workspaceGroupSize = 10

terminal =
"~/.config/hypr/hyprland/scripts/launch_first_available.sh 'foot' 'kitty -1' 'alacritty'"

fileManager =
"~/.config/hypr/hyprland/scripts/launch_first_available.sh 'dolphin' 'nautilus' 'thunar'"

browser =
"~/.config/hypr/hyprland/scripts/launch_first_available.sh 'firefox' 'zen-browser' 'google-chrome-stable'"

codeEditor =
"~/.config/hypr/hyprland/scripts/launch_first_available.sh 'code' 'codium' 'zed'"

officeSoftware =
"~/.config/hypr/hyprland/scripts/launch_first_available.sh 'libreoffice'"

textEditor =
"~/.config/hypr/hyprland/scripts/launch_first_available.sh 'kate' 'nano'"

volumeMixer =
"~/.config/hypr/hyprland/scripts/launch_first_available.sh 'pavucontrol'"

settingsApp =
"XDG_CURRENT_DESKTOP=gnome ~/.config/hypr/hyprland/scripts/launch_first_available.sh 'systemsettings' 'gnome-control-center'"

taskManager =
"~/.config/hypr/hyprland/scripts/launch_first_available.sh 'btop' 'gnome-system-monitor'"