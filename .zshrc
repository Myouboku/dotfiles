export PATH=$PATH:/home/hugo/.cargo/bin

# import output colors
source ~/.zsh_colors

# Helpful aliases
alias c='clear' # clear terminal
alias l='eza -lh --icons=auto' # long list
alias ls='eza -1 --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias lg='lazygit' # git tui

# Directory navigation shortcuts
alias cd='z'
alias ..='cd ..'
alias ...='cd ../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

# Display Pokemon
pokemon-colorscripts --no-title -r 1,3,6

eval "$(zoxide init zsh)"
eval $(thefuck --alias)

# TODO configure fzf
# fzf configuration
source <(fzf --zsh)
# export FZF_DEFAULT_OPTS='--preview "bat --color=always --line-range=:500 {}"'

# nvm node manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# yazi memorise directory on quit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# cat configuration
function help() {
    "$@" --help 2>&1 | bat --plain --language=help
}
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

function formatToTable() {
  (echo -e "Name\tApplication ID\tVersion\tBranch\tArch"; cat $1) |
    sed 's/\t/;/g' |
    column -s ';' -t
}

# List all available updates through pacman, the AUR and flatpak
function cu() {
  pacmanFile="/tmp/pacmanUpdates.txt"
  aurFile="/tmp/aurUpdates.txt"
  flatpakFile="/tmp/flatpakUpdates.txt"

  printf '%*s\n' "$(tput cols)" '' | tr ' ' '-'

  echo -e "${BIYellow}$(figlet Pacman)${Color_Off}\n"
  checkupdates | tee $pacmanFile
  echo "\n${BIYellow}Available updates : $(cat $pacmanFile | wc -l)${Color_Off}"

  printf '%*s\n' "$(tput cols)" '' | tr ' ' '-'

  echo -e "${BIBlue}$(figlet AUR)${Color_Off}\n"
  yay -Qua --color=always | tee $aurFile
  echo "\n${BIBlue}Available updates : $(cat $aurFile | wc -l)${Color_Off}"

  printf '%*s\n' "$(tput cols)" '' | tr ' ' '-'

  echo -e "${BIPurple}$(figlet Flatpak)${Color_Off}\n"
  flatpak remote-ls --updates > $flatpakFile
  formatToTable $flatpakFile
  echo "\n${BIPurple}Available updates : $(cat $flatpakFile | wc -l)${Color_Off}"

  printf '%*s\n' "$(tput cols)" '' | tr ' ' '-'

  echo -e "${IRed}Total available updates : $(cat $pacmanFile $aurFile $flatpakFile | wc -l)${Color_Off}"
}
