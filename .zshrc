export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
HIST_STAMPS="dd/mm/yyyy"

plugins=(git dnf node nvm npm fzf ssh ssh-agent gh zoxide thefuck tmux)

source $ZSH/oh-my-zsh.sh

fastfetch
