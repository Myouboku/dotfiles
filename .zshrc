export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="suvash" # set by `omz`
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOQUIT=false

zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'icons' yes
zstyle ':omz:plugins:eza' 'hyperlink' yes
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zstyle :omz:plugins:ssh-agent quiet yes

# cargo binaries must be in path before omz load for eza
export PATH=$PATH:$HOME/.cargo/bin

plugins=(git nvm npm fzf ssh ssh-agent gh zoxide eza sudo tmux zsh-autosuggestions zsh-syntax-highlighting you-should-use)

source $ZSH/oh-my-zsh.sh

eval $(thefuck --alias)
