#!/bin/bash

toggle_bar() {
    BAR_ID=`xdo id -a "$1"`
    if xprop -id $BAR_ID | grep -q "Normal"; then
        xdo hide -r $BAR_ID
    else
        xdo show -r $BAR_ID
    fi
    return 0
}

case "$1" in
    --top | -t)
        toggle_bar "polybar-top_eDP1"
        ;;
    --bottom | -b)
        toggle_bar "polybar-bottom_eDP1"
        ;;
esac
