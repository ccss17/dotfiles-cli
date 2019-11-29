#!/bin/bash

WORKING_DIR=$PWD
ORIGIN=`git remote get-url origin | cut -d'/' -f4`

#
# install rc files
#
[[ -f ~/.gitconfig ]] && mv ~/.gitconfig ~/.gitconfig.bak
[[ -f ~/.gitignore ]] && mv ~/.gitignore ~/.gitignore.bak
[[ -f ~/.aliases ]] && mv ~/.aliases ~/.aliases.bak
[[ -f ~/.vimrc ]] && mv ~/.vimrc ~/.vimrc.bak
[[ -f ~/.tmux.conf ]] && mv ~/.tmux.conf ~/.tmux.conf.bak
cp _gitconfig ~/.gitconfig
cp _gitignore ~/.gitignore
cp _aliases ~/.aliases
cp _vimrc ~/.vimrc
cp _tmux.conf ~/.tmux.conf

#
# install package
#
distro=$(cat /etc/os-release | grep "^ID=" | cut -d\= -f2 | sed -e 's/"//g')
case "$distro" in
"ubuntu")
    # install git, zsh, vim, tmux
    sudo apt-get install git zsh vim tmux unzip -y
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
    sudo pacman -S git zsh vim tmux bat fd unzip
    ;;
esac

#
# install oh-my-zsh
#
[[ ! -d ~/.oh-my-zsh ]] && sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
[[ -f ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc.bak
cp _zshrc ~/.zshrc
[[ ! -f ~/.oh-my-zsh/themes/cdimascio-lambda.zsh-theme ]] && \
    export ZSH_CUSTOM=~/.oh-my-zsh/custom
    git clone --recurse-submodules https://github.com/eendroroy/alien-minimal.git ${ZSH_CUSTOM}/themes/alien-minimal

    cd ${ZSH_CUSTOM}/themes/alien-minimal
    git clone https://github.com/eendroroy/alien-minimal.git
    git submodule update --init --recursive
[[ ! -d ~/.oh-my-zsh/plugins/zsh-autosuggestions ]] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ~/.oh-my-zsh/plugins/zsh-autosuggestions

#
# install vim-plug
#
[[ ! -f ~/.vim/colors/monokai_pro.vim ]] && \
    curl -fLo ~/.vim/colors/monokai_pro.vim --create-dirs \
        https://raw.githubusercontent.com/phanviet/vim-monokai-pro/master/colors/monokai_pro.vim
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    #vim -c PlugInstall
    vim +PlugInstall +qall
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
