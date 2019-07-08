#!/bin/sh
SIZE_HDMI='15.0'
SIZE_eDP1='11.0'

if [ ! $(xrandr --query | grep " connected" | wc -l) == 1 ]; then
    xrandr --query --output HDMI2 --primary --mode 1920x1080 --same-as eDP1
    xrandr --query --output eDP1 --primary --mode 1920x1080 --same-as HDMI2
fi

PRIMARY=$(xrandr --query | grep primary | cut -d' ' -f1)
if [ $PRIMARY == "HDMI2" ]; then
    sed -i "/  size: $SIZE_eDP1/c\  size: $SIZE_HDMI" ~/.config/alacritty/alacritty.yml
else
    sed -i "/  size: $SIZE_HDMI/c\  size: $SIZE_eDP1" ~/.config/alacritty/alacritty.yml
fi
