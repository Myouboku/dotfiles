export PATH=$PATH:$HOME/bin/Sencha/Cmd:$HOME/.local/bin

# neovim for everything
export VISUAL="nvim"
export EDITOR="nvim"
export MANPAGER="nvim +Man!"

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# bug with thefuck : https://github.com/nvbn/thefuck/issues/1153
export THEFUCK_EXCLUDE_RULES='fix_file'
