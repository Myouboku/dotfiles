# fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# nvm node manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# add cargo to path
export PATH=$PATH:/home/hugo/.cargo/bin:/home/hugo/bin/Sencha/Cmd

# neovim for everything
export VISUAL="nvim"
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
