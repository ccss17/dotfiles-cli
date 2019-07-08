#!/bin/bash

case "$1" in
*)
state=$(xbacklight)
if [ $state == "5.000000" ]; then
    xbacklight -set 100
else
    xbacklight -set 5
fi
;;
--inc)
xbacklight -inc 15
;;
--dec)
xbacklight -dec 15
;;
esac
