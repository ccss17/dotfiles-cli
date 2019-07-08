#!/bin/bash
day=`date +%w`
case "$day" in
"0")
echo `date +%a`
;;
"6")
echo `date +%a`
;;
*)
echo `date +%a`
;;
esac
