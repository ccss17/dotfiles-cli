#!/bin/bash

WORKING_DIR=$PWD

#
# install rc files
#
cp _gitconfig ~/.gitconfig
cp _gitignore ~/.gitignore
cp _zsh_aliases ~/.zsh_aliases
cp _vimrc ~/.vimrc
cp _tmux.conf ~/.tmux.conf

#
# install package
#
distro=$(cat /etc/os-release | grep "^ID=" | cut -d\= -f2 | sed -e 's/"//g')
case "$distro" in
"ubuntu")
    # install git, zsh, vim, tmux, gdb
    sudo apt-get install git zsh vim tmux gdb 
    # install fd
    if ! type -p fd>/dev/null; then
        ZIPFILE="fd.deb"
        VERSION=`curl -s https://github.com/sharkdp/fd/releases/latest | cut -d '"' -f 2 | cut -d '/' -f 8`
        wget -O $ZIPFILE -q https://github.com/sharkdp/fd/releases/download/$VERSION/fd_${VERSION:1}_amd64.deb
        sudo dpkg -i $ZIPFILE
    fi
    # install bat
    if ! type -p bat>/dev/null; then
        ZIPFILE="bat.deb"
        VERSION=`curl -s https://github.com/sharkdp/bat/releases/latest | cut -d '"' -f 2 | cut -d '/' -f 8`
        wget -O $ZIPFILE -q https://github.com/sharkdp/bat/releases/download/$VERSION/bat_${VERSION:1}_amd64.deb
        sudo dpkg -i $ZIPFILE
    fi
    ;;
"arch")
    # install git, zsh, vim, tmux, gdb, bat, fd, pwndbg
    sudo pacman -S git zsh vim tmux gdb bat fd 
    ;;
esac

#
# install pwndbg
#
if [ -f ~/.gdbinit ]; then
    mv ~/.gdbinit ~/.gdbinit.bak
fi
git clone https://github.com/pwndbg/pwndbg ~/pwndbg
cd ~/pwndbg
./setup.sh
cd $WORKING_DIR
cp _gdbinit ~/.gdbinit

#
# install oh-my-zsh
#
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
cp _zshrc ~/.zshrc
if [ ! -f ~/.oh-my-zsh/themes/cdimascio-lambda.zsh-theme ]; then
    curl -fLo ~/.oh-my-zsh/themes/cdimascio-lambda.zsh-theme \
        https://raw.githubusercontent.com/cdimascio/lambda-zsh-theme/master/cdimascio-lambda.zsh-theme
fi
if [ ! -d ~/.oh-my-zsh/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ~/.oh-my-zsh/plugins/zsh-autosuggestions
fi

#
# install vim-plug
#
if [ ! -f ~/.vim/colors/monokai_pro.vim ]; then
    curl -fLo ~/.vim/colors/monokai_pro.vim --create-dirs \
        https://raw.githubusercontent.com/phanviet/vim-monokai-pro/master/colors/monokai_pro.vim
fi
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim -c PlugInstall
fi

#
# install exa
#
if ! type -p exa>/dev/null; then
    ZIPFILE="exa.zip"
    VERSION=`curl -s https://github.com/ogham/exa/releases/latest | cut -d '"' -f 2 | cut -d '/' -f 8`
    wget -O $ZIPFILE -q https://github.com/ogham/exa/releases/download/$VERSION/exa-linux-x86_64-${VERSION:1}.zip
    unzip $ZIPFILE
    sudo mv exa-linux-x86_64 /usr/bin/exa
fi
