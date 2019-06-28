#!/bin/sh
PATH=$PATH:$PWD
distro=`getdistro.sh`
case "$(getdistro.sh)" in
    "Ubuntu"*)
        sudo apt-get install git zsh vim tmux gdb
        ;;
    "Arch"*)
        sudo pacman -S git zsh vim tmux gdb
        ;;
esac

cp .gitconfig ~
cp .gitignore ~

cp .zsh_aliases ~
sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/cdimascio/lambda-zsh-theme
cp lambda-zsh-theme/cdimascio-lambda.zsh-theme ~/.oh-my-zsh/themes
git clone https://github.com/zsh-users/zsh-autosuggestions \ 
    ~/.oh-my-zsh/plugins/zsh-autosuggestions

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cp .vimrc ~

