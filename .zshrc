export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="suvash" # set by `omz`

zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'header' yes
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'hyperlink' yes
zstyle ':omz:plugins:nvm' lazy yes

# cargo binaries must be in path before omz load for eza
export PATH=$PATH:$HOME/.cargo/bin

plugins=(git dnf node nvm npm fzf ssh ssh-agent gh zoxide thefuck tmux eza sudo)

source $ZSH/oh-my-zsh.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
