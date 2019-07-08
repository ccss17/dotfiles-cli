#!/bin/sh
STATE=$(amixer get Master | grep "\[on\]")
if [ -z "$STATE" ]; then
    amixer set Master unmute
    alsactl restore
else
    amixer set Master mute
fi
