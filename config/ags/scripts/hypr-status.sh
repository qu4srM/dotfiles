#!/usr/bin/env bash



case $1 in
    workspacenumber)
        hyprctl activeworkspace | head -n 1 | awk '{print $3}'
    ;;
esac