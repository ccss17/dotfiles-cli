#!/bin/bash

#
# install rc files
#
cp _gitconfig ~
cp _gitignore ~
cp _zsh_aliases ~
cp _vimrc ~
cp _tmux.conf ~

#
# install package
#
PATH=$PATH:$PWD
distro=`getdistro.sh`
case "$(getdistro.sh)" in
"Ubuntu"*)
    sudo apt-get install git zsh vim tmux gdb fd-find
    if ! type -p bat>/dev/null; then
        ZIPFILE="bat.deb"
        VERSION=`curl -s https://github.com/sharkdp/bat/releases/latest | cut -d '"' -f 2 | cut -d '/' -f 8`
        wget -O $ZIPFILE -q https://github.com/sharkdp/bat/releases/download/$VERSION/bat_${VERSION:1}_amd64.deb
        sudo dpkg -i $ZIPFILE
    fi
    ;;
"Arch"*)
    sudo pacman -S git zsh vim tmux gdb bat fd
    ;;
esac

#
# install oh-my-zsh
#
if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
cp _zshrc ~
if [ ! -f ~/.oh-my-zsh/themes/cdimascio-lambda.zsh-theme ]; then
    git clone https://github.com/cdimascio/lambda-zsh-theme
    cp lambda-zsh-theme/cdimascio-lambda.zsh-theme ~/.oh-my-zsh/themes
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
# install gdb-gef
#
if [ ! -f ~/.gdbinit-gef.py ]; then
    wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh
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