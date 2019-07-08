#!/bin/bash
killall -q polybar
source ~/.cache/wal/colors.sh
export color0_alpha="#aa${color0/'#'}"
polybar top &
polybar bottom &
