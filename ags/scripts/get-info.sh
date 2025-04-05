#!/usr/bin/env bash
percentage=`amixer get Master | grep % | head -n 1 | cut -d "[" -f 2 | cut -d "%" -f 1`
percentageCapture=`amixer get Capture | grep % | head -n 1 | cut -d "[" -f 2 | cut -d "%" -f 1`


case $1 in
	getvolume)
    amixer get Master | grep % | head -n 1 | cut -d "[" -f 2 | cut -d "]" -f 1
	;;
	getsumvolume)
    num=$(($percentage))
    echo "scale=2;$num/100" | bc
	;;
	getcapture)
	amixer get Capture | grep % | head -n 1 | cut -d "[" -f 2 | cut -d "]" -f 1
	;;
	getsumcapture)
	num2=$(($percentageCapture))
    echo "scale=2;$num2/100" | bc
	;;
esac
