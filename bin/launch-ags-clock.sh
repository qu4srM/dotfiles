#!/usr/bin/env bash

ags quit -i clock
sleep 7 &
ags run ~/.config/ags/widget/appClock.ts
