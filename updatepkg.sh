#!/bin/sh
PATH=$PATH:$PWD
distro=$(cat /etc/os-release | grep "^ID=" | cut -d\= -f2 | sed -e 's/"//g')
case "$distro" in
    "ubuntu")
        sudo apt-get update && sudo apt-get upgrade -y
        ;;
    "arch")
        sudo pacman -Syu
        ;;
esac
