#!/bin/bash
STATUS=`systemctl is-active bluetooth.service`

case "$1" in
--status)
    if [ $STATUS == "active" ]
    then
        icon=""
        echo "%{F#30a9de}$icon%{F-} ON"
    else
        icon=""
        echo "%{F#55}$icon OFF"
    fi
;;
--toogle)
    if [ $STATUS == "active" ]
    then
        SUDO_ASKPASS="$HOME/.config/polybar/script/zenity-pw-prompt.sh" sudo -A systemctl stop bluetooth
    else
        SUDO_ASKPASS="$HOME/.config/polybar/script/zenity-pw-prompt.sh" sudo -A systemctl start bluetooth
    fi
;;
esac
