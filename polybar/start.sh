#!/bin/bash
killall -q polybar
source ~/.cache/wal/colors.sh
export color0_alpha="#aa${color0/'#'}"
nohup polybar top > /dev/null 2>&1&
nohup polybar bottom > /dev/null 2>&1&
