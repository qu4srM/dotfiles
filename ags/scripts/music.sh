#!/usr/bin/env bash

state=`playerctl status`
length=``
folder="$HOME/.config/ags/assets/img"
function get_icon {
    app=`playerctl metadata | awk '{print $1}' | head -n 1`
    if [ $app = "firefox" ];then
        echo "firefox"
    elif [ $app = "spotify" ];then
        echo "spotify"
    fi
}

function get_artist {
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/artist/{n;n;p}' | cut -d '"' -f 2
}
function get_title {
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d '"' -f 2
}
function get_image {
    url=`playerctl metadata | grep 'artUrl' | awk '{print $3}'`
    curl -o $folder/coverArt.jpg $url
}
function get_length {
    playerctl metadata | grep length | awk '{print $3}' | cut -c 1,2,3
}
function get_position {
    playerctl position
}
function pause_or-play {
    playerctl play-pause
}
function stop {
    playerctl stop
}
function set_previous {
    playerctl previous
}
function set_next {
    playerctl next
}
    

case $1 in
    geticon)
    get_icon
    ;;
    getlength)
    get_length
    ;;
    getposition)
    get_position
    ;;
    getartist)
	get_artist
	;;
    gettitle)
    get_title
    ;;
    getimage)
    get_image
    ;;
    playorpause)
    pause_or-play
    ;;
    previous)
    set_previous
    ;;
    next)
    set_next
    ;;
esac
