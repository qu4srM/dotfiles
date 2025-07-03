#!/usr/bin/env bash

FILE="/tmp/screenshot_$(date '+%Y-%m-%d_%H-%M-%S').png"
grim -g "$(slurp)" "$FILE" && wl-copy < "$FILE"
cp "$FILE" ~/Pictures/