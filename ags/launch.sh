#!/usr/bin/env bash

FILEVOL="$HOME/.cache/vol-ags.lock"
FILEMUSIC="$HOME/.cache/music-ags.lock"
FILEWIFI="$HOME/.cache/wifi-ags.lock"
FILESIDEBAR="$HOME/.cache/sidebar-ags.lock"

function launch_vol {
    if [[ ! -f "$FILEVOL" ]]; then
        touch "$FILEVOL"
        ags --bus-name volume -c ~/.config/ags/configVol.js
    elif [[ -f "$FILEVOL" ]]; then
        ags -q --bus-name volume -c ~/.config/ags/configVol.js
        rm -rf "$FILEVOL"
    fi
}
case $1 in
    launch)
        ags quit -i js
        sleep 5 &
        ags run ~/.config/ags/app.ts
    ;;
    sidebar)
        ags -i js request sidebar
    ;;
    media)
        ags -i js request media
	;;
    hack)
        ags -i js request hack
    ;;
    quit)
        ags quit -i js
    ;;
	launchvol)
        ags run ~/.config/ags/appVol.ts
	;;
    stopvol)
        ags quit -i volume
    ;;
    launchmusic)
    launch_music
	;;
    sidebarstatus)
        cat ~/.config/ags/cache/sidebar.txt 
    ;;
    launchwifi)
    launch_wifi
    ;;
    launchwlogout)
    bash ~/.config/wlogout/launch.sh
    ;;
esac
