export PATH=$PATH:$HOME/.cargo/bin:$HOME/bin/Sencha/Cmd:$HOME/.local/bin

# neovim for everything
export VISUAL="nvim"
export EDITOR="nvim"
export MANPAGER="nvim +Man!"

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
