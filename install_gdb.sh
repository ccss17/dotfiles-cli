#!/bin/bash

WORKING_DIR=$PWD
ORIGIN=`git remote get-url origin | cut -d'/' -f4`

#
# install gdb
#
distro=$(cat /etc/os-release | grep "^ID=" | cut -d\= -f2 | sed -e 's/"//g')
case "$distro" in
"ubuntu")
    # install gdb
    sudo apt-get install gdb -y
    ;;
"arch")
    sudo pacman -S gdb 
    ;;
esac

#
# install pwndbg
#
install_mypwndbg() {
    git clone https://github.com/$ORIGIN/pwndbg ~/pwndbg
    cd ~/pwndbg
    ./setup.sh
    cd $WORKING_DIR
}
[[ -f ~/.gdbinit ]] && mv ~/.gdbinit ~/.gdbinit.bak
if [ -d ~/pwndbg ]; then
    cd ~/pwndbg
    AUTHOR=`git remote get-url origin | cut -d'/' -f4`
    if [ $AUTHOR == $ORIGIN ]; then
        git pull origin
    else
        cd
        mv ~/pwndbg ~/pwndbg.bak
        install_mypwndbg
    fi
else
    install_mypwndbg
fi
[[ -f ~/.gdbinit ]] && mv ~/.gdbinit ~/.gdbinit.bak
cp _gdbinit ~/.gdbinit
