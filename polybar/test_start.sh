#!/bin/bash
killall -q polybar
source ~/.cache/wal/colors.sh
export color0_alpha="#aa${color0/'#'}"

polybar top &
polybar test &

#if type "xrandr">/dev/null; then
  #for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    ##MONITOR=$m polybar --reload example &
    #MONITOR=$m nohup polybar --reload top > /dev/null 2>&1&
    #MONITOR=$m nohup polybar --reload bottom > /dev/null 2>&1&
    #echo 1
  #done
#else
  #nohup polybar --reload top > /dev/null 2>&1&
  #nohup polybar --reload bottom > /dev/null 2>&1&
  ## polybar --reload example &
#fi

