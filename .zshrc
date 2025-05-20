export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="suvash" # set by `omz`
HIST_STAMPS="dd/mm/yyyy"

zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'header' yes
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'hyperlink' yes
zstyle ':omz:plugins:nvm' lazy yes

# cargo binaries must be in path before omz load for eza
export PATH=$PATH:$HOME/.cargo/bin

plugins=(git dnf node nvm npm fzf ssh ssh-agent gh zoxide thefuck tmux eza sudo)

source $ZSH/oh-my-zsh.sh
