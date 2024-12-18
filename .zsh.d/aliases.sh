alias c='clear' # clear terminal

alias l='eza -lh --icons=auto' # long list
alias ls='eza -1 --icons=auto' # short list
alias la='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias lg='lazygit' # git tui

alias ..='cd ..'
alias ...='cd ../..'

alias mkdir='mkdir -p'

alias grep="grep --color=always"
alias grepi="grep -i --color=always"

alias tmuxa="tmux attach -t"
alias tmuxn="tmux new -s"

alias port-forwarding="\$HOME/scripts/port_forwarding.sh"
alias unitstatus="\$HOME/scripts/unitstatus.sh"
alias cu="\$HOME/scripts/checkupdates.sh"

alias dev='export NODE_ENV=development && nodemon --inspect -e js,cjs,mjs,sql'
