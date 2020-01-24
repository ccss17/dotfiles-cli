#!/bin/bash

#
# install rc files
#
[[ -f ~/.gitconfig ]] && mv ~/.gitconfig ~/.gitconfig.bak
[[ -f ~/.gitignore ]] && mv ~/.gitignore ~/.gitignore.bak
[[ -f ~/.zsh_aliases ]] && mv ~/.zsh_aliases ~/.zsh_aliases.bak
[[ -f ~/.vimrc ]] && mv ~/.vimrc ~/.vimrc.bak
[[ -f ~/.tmux.conf ]] && mv ~/.tmux.conf ~/.tmux.conf.bak
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
"ubuntu" | "kali")
    # install git, zsh, vim, tmux
    sudo apt-get install git zsh vim tmux unzip -y
    # install fd
    if ! type fd>/dev/null; then
        ZIPFILE="fd.deb"
        VERSION=`curl -s https://github.com/sharkdp/fd/releases/latest | cut -d '"' -f 2 | cut -d '/' -f 8`
        wget -O $ZIPFILE -q https://github.com/sharkdp/fd/releases/download/$VERSION/fd_${VERSION:1}_amd64.deb
        sudo dpkg -i $ZIPFILE
    fi
    # install bat
    if ! type bat>/dev/null; then
        DEBFILE="bat.deb"
        VERSION=`curl -s https://github.com/sharkdp/bat/releases/latest | cut -d '"' -f 2 | cut -d '/' -f 8`
        wget -O $DEBFILE -q https://github.com/sharkdp/bat/releases/download/$VERSION/bat_${VERSION:1}_amd64.deb
        sudo dpkg -i $DEBFILE
    fi
    if ! type lsd>/dev/null; then
        sudo apt-get install fonts-hack-ttf
        DEBFILE="lsd.deb"
        VERSION=`curl -s https://github.com/Peltoche/lsd/releases/latest | cut -d '"' -f 2 | cut -d '/' -f 8`
        wget -O $DEBFILE -q https://github.com/Peltoche/lsd/releases/download/$VERSION/lsd_${VERSION}_amd64.deb
        sudo dpkg -i $DEBFILE
    fi
    ;;
"arch")
    yay -S --noconfirm nerd-fonts-hack
    sudo pacman -S --noconfirm git zsh vim tmux bat fd unzip lsd
    ;;
esac

#
# tmux 2.x config
#
TMUX_VERSION=$(tmux -V | cut -d' ' -f2)
if [[ "${TMUX_VERSION:0:1}" == "2" ]]; then
    sed -i 's/bind \\\\ split-window -h/bind \\ split-window -h/g' ~/.tmux.conf
fi

#
# install vim-plug
#
if [[ ! -f ~/.vim/autoload/onedark.vim ]]; then
    curl -fLo ~/.vim/autoload/onedark.vim --create-dirs \
        https://raw.githubusercontent.com/joshdick/onedark.vim/master/autoload/onedark.vim
fi
if [[ ! -f ~/.vim/colors/onedark.vim ]]; then
    curl -fLo ~/.vim/colors/onedark.vim --create-dirs \
        https://raw.githubusercontent.com/joshdick/onedark.vim/master/colors/onedark.vim
fi
if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall +qall
fi

#
# install oh-my-zsh
#
if [[ ! -d ~/.oh-my-zsh ]]; then
    wget -O install_ohmyzsh.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
    RUNZSH=no sh install_ohmyzsh.sh
fi
rm install_ohmyzsh.sh
[[ -f ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc.bak
cp _zshrc ~/.zshrc
[[ ! -d ~/.oh-my-zsh/custom/themes/alien-minimal ]] && \
    git clone --recurse-submodules https://github.com/eendroroy/alien-minimal.git \
        ~/.oh-my-zsh/custom/themes/alien-minimal
[[ ! -d ~/.oh-my-zsh/plugins/zsh-autosuggestions ]] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ~/.oh-my-zsh/plugins/zsh-autosuggestions

exec zsh -l
