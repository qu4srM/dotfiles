#!/usr/bin/env bash

FILEBAR="$HOME/.cache/togglebar-ags.lock"

init () {
    ags quit -i js
    sleep 5 &
    ags run ~/.config/ags/app.ts request bartop
}

case $1 in
    launch)
        init
    ;;
    barleft)
        sed -i 's/export const activeBar = Variable("bartop")/export const activeBar = Variable("barleft")/' ~/.config/ags/utils/initvars.ts
        init
    ;;
    bartop)
        sed -i 's/export const activeBar = Variable("barleft")/export const activeBar = Variable("bartop")/' ~/.config/ags/utils/initvars.ts
        init
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
    screenshot)
        ags -i js request screenshot
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
    launchwlogout)
    bash ~/.config/wlogout/launch.sh
    ;;
esac
