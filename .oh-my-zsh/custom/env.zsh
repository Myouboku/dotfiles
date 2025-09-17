# sencha cmd
export PATH=$PATH:$HOME/bin/Sencha/Cmd
# local binaries
export PATH=$PATH:$HOME/.local/bin
# lazygit
export PATH=$PATH:/opt/lazygit
# opencode
export PATH=$PATH:$HOME/.opencode/bin

# neovim for everything
export VISUAL="nvim"
export EDITOR="nvim"
export MANPAGER="nvim +Man!"

# sdkman
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# bug with thefuck : https://github.com/nvbn/thefuck/issues/1153
export THEFUCK_EXCLUDE_RULES='fix_file'

# puppeteer cache path override for dev
export PUPPETEER_CACHE_DIR="$HOME/.cache/puppeteer"
