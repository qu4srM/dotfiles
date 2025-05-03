#!/usr/bin/env bash

case $1 in
    all)
        grim ~/Pictures/screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png
    ;;
    monitor)
        whoami
    ;;
    area)
        grim -g "$(slurp)" ~/Pictures/screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png
	;;
esac
