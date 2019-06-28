#!/bin/sh
PATH=$PATH:$PWD
distro=`getdistro.sh`
case "$(getdistro.sh)" in
    "Ubuntu"*)
        sudo apt-get update && sudo apt-get upgrade -y
        ;;
    "Arch"*)
        sudo pacman -Syu
        ;;
esac
