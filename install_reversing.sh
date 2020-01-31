#!/bin/bash

if [[ $UID == 0 ]]; then
    CMD=""
else
    CMD="sudo "
fi
 distro=$(cat /etc/os-release | grep "^ID=" | cut -d\= -f2 | sed -e 's/"//g')
 case "$distro" in
 "ubuntu")
     $CMD dpkg --add-architecture i386
     $CMD apt-get update
     $CMD apt-get install -y gdb radare2 libc6:i386 libncurses5:i386 libstdc++6:i386
     #$CMD apt-get install -y gdb radare2 multiarch-support
     git clone https://github.com/pwndbg/pwndbg
     cd pwndbg
     ./setup.sh
     cd ..
     mv pwndbg ~
     ;;
 "arch")
     $CMD pacman -S --noconfirm gdb pwndbg radare2 lib32-glibc 
     #pacman -S lib32-glibc lib32-ncurses lib32-libstdc++5
     ;;
 esac

r2pm init
r2pm install r2dec

 [[ -f ~/.gdbinit ]] && mv ~/.gdbinit ~/.gdbinit.bak
 cp _gdbinit ~/.gdbinit
 if [[ -d /usr/share/pwndbg ]]; then
     sed -i "s/source ~\/pwndbg\/gdbinit.py/source \/usr\/share\/pwndbg\/gdbinit.py/g" ~/.gdbinit
 fi

