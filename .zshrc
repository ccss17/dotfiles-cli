export TERM="xterm-256color"
export ZSH="$HOME/.oh-my-zsh"
export INTERFACES="wlp2s0"
export LANG="en_US.UTF-8"
PATH=$PATH:~/.local/bin
ZSH_THEME="alien-minimal/alien-minimal"
plugins=( 
  z 
  zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh
stty -ixon
source ~/.zsh_aliases
