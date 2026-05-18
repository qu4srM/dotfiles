#!/usr/bin/env sh

STATE=$(hyprctl getoption animations:enabled | awk 'NR==1 {print $2}')

if [ "$STATE" = "1" ]; then
    notify-send "Boost Mode" "Disable animation"

    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:blur:enabled 0;\
        keyword decoration:shadow:enabled 0;\
        keyword decoration:rounding 0;\
        keyword general:border_size 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:gaps_workspaces 0;\
        keyword decoration:dim_inactive 0;\
        keyword misc:vfr 1"
else
    notify-send "Normal Mode" "Restore configuration"

    hyprctl reload
fi