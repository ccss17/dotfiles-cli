#!/bin/bash

#
# install package
#
if [[ $UID == 0 ]]; then
    SUDO=""
else
    SUDO="sudo "
fi
distro=$(cat /etc/os-release | grep "^ID=" | cut -d\= -f2 | sed -e 's/"//g')
case "$distro" in
"ubuntu" | "kali")
    # install git, zsh, vim, tmux
    $SUDO apt-get -y -qq install git zsh vim tmux unzip curl wget 
    # install fd
    if ! type fd 2>/dev/null; then
        ZIPFILE="fd.deb"
        VERSION=`curl -s https://github.com/sharkdp/fd/releases/latest | cut -d '"' -f 2 | cut -d '/' -f 8`
        wget -q -O $ZIPFILE -q https://github.com/sharkdp/fd/releases/download/$VERSION/fd_${VERSION:1}_amd64.deb
        $SUDO dpkg -i $ZIPFILE
    fi
    # install bat
    if ! type bat 2>/dev/null; then
        DEBFILE="bat.deb"
        VERSION=`curl -s https://github.com/sharkdp/bat/releases/latest | cut -d '"' -f 2 | cut -d '/' -f 8`
        wget -q -O $DEBFILE -q https://github.com/sharkdp/bat/releases/download/$VERSION/bat_${VERSION:1}_amd64.deb
        $SUDO dpkg -i $DEBFILE
    fi
    if ! type lsd 2>/dev/null; then
        DEBFILE="lsd.deb"
        VERSION=`curl -s https://github.com/Peltoche/lsd/releases/latest | cut -d '"' -f 2 | cut -d '/' -f 8`
        wget -q -O $DEBFILE -q https://github.com/Peltoche/lsd/releases/download/$VERSION/lsd_${VERSION}_amd64.deb
        $SUDO dpkg -i $DEBFILE
    fi
    if ! type lsd 2>/dev/null; then
        wget -q "https://github.com/sharkdp/hexyl/releases/download/v0.6.0/hexyl_0.6.0_amd64.deb"
        $SUDO dpkg -i hexyl_0.6.0_amd64.deb
    fi

    ;;
"arch")
    $SUDO pacman -S --noconfirm git zsh vim tmux bat fd unzip lsd curl wget hexyl
    ;;
esac

#
# install oh-my-zsh
#
if [[ ! -d ~/.oh-my-zsh ]]; then
    wget -q -O install_ohmyzsh.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
    # CHSH=no RUNZSH=no sh install_ohmyzsh.sh
    sh install_ohmyzsh.sh --unattended
    rm install_ohmyzsh.sh
fi
# [[ -f ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc.bak
# cp _zshrc ~/.zshrc
[[ ! -d ~/.oh-my-zsh/custom/themes/alien-minimal ]] && \
    git clone -q --recurse-submodules https://github.com/eendroroy/alien-minimal.git \
        ~/.oh-my-zsh/custom/themes/alien-minimal
[[ ! -d ~/.oh-my-zsh/plugins/zsh-autosuggestions ]] && \
    git clone -q https://github.com/zsh-users/zsh-autosuggestions \
        ~/.oh-my-zsh/plugins/zsh-autosuggestions

# exec zsh -l
# $SUDO chsh -s $(which zsh)

#
# install rc files
#
# [[ -f ~/.gitconfig ]] && mv ~/.gitconfig ~/.gitconfig.bak
# [[ -f ~/.gitignore ]] && mv ~/.gitignore ~/.gitignore.bak
# [[ -f ~/.zsh_aliases ]] && mv ~/.zsh_aliases ~/.zsh_aliases.bak
# [[ -f ~/.vimrc ]] && mv ~/.vimrc ~/.vimrc.bak
# [[ -f ~/.tmux.conf ]] && mv ~/.tmux.conf ~/.tmux.conf.bak
# cp .gitconfig ~/.gitconfig
# cp .gitignore ~/.gitignore
# cp .zsh_aliases ~/.zsh_aliases
# cp .vimrc ~/.vimrc
# cp .tmux.conf ~/.tmux.conf
# cp .amrc ~/.amrc

for file in $(find $CURDIR -type f -name ".*" -not -name "_gdbinit"); do 
    f=$(basename $file)
    ln -sf $PWD/$file $HOME/$f; 
done

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
    curl -sfLo ~/.vim/autoload/onedark.vim --create-dirs \
        https://raw.githubusercontent.com/joshdick/onedark.vim/master/autoload/onedark.vim
fi
if [[ ! -f ~/.vim/colors/onedark.vim ]]; then
    curl -sfLo ~/.vim/colors/onedark.vim --create-dirs \
        https://raw.githubusercontent.com/joshdick/onedark.vim/master/colors/onedark.vim
fi
if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
    curl -sfLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +PlugInstall +qall
fi
