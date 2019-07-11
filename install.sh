#!/bin/bash

WORKING_DIR=$PWD
ORIGIN=`git remote get-url origin | cut -d'/' -f4`
echo $ORIGIN

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
    sudo pacman -S git zsh vim tmux gdb bat fd 
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
cp _gdbinit ~/.gdbinit

#
# install oh-my-zsh
#
[[ ! -d ~/.oh-my-zsh ]] && sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
[[ -f ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc.bak
cp _zshrc ~/.zshrc
[[ ! -f ~/.oh-my-zsh/themes/cdimascio-lambda.zsh-theme ]] && \
    curl -fLo ~/.oh-my-zsh/themes/cdimascio-lambda.zsh-theme \
        https://raw.githubusercontent.com/cdimascio/lambda-zsh-theme/master/cdimascio-lambda.zsh-theme
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
