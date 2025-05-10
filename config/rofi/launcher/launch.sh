#!/usr/bin/env bash


FILE="$HOME/.cache/rofi-launcher.lock"
dir="$HOME/.config/rofi/launcher/"
theme='colors'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi

