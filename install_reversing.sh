#!/bin/bash

 distro=$(cat /etc/os-release | grep "^ID=" | cut -d\= -f2 | sed -e 's/"//g')
 case "$distro" in
 "ubuntu")
     sudo dpkg --add-architecture i386
     sudo apt-get update
     sudo apt-get install -y gdb radare2 libc6:i386 libncurses5:i386 libstdc++6:i386
     #sudo apt-get install -y gdb radare2 multiarch-support
     git clone https://github.com/pwndbg/pwndbg
     cd pwndbg
     ./setup.sh
     ;;
 "arch")
     sudo pacman -S --noconfirm gdb pwndbg radare2 lib32-glibc 
     #pacman -S lib32-glibc lib32-ncurses lib32-libstdc++5
     r2pm init
     r2pm install r2dec
     ;;
 esac

 [[ -f ~/.gdbinit ]] && mv ~/.gdbinit ~/.gdbinit.bak
 cp _gdbinit ~/.gdbinit

