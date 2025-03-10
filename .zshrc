eval "$(starship init zsh)"

ZSH_D="$HOME/.zsh.d"
if [[ -d "$ZSH_D" ]]; then
    for file in "$ZSH_D"/*.sh; do
        [[ -r "$file" ]] && source "$file"
    done
    unset file
fi

eval "$(zoxide init zsh)"
eval "$(thefuck --alias)"
source <(fzf --zsh)

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# trick to prevent errors on ssh with ghostty
if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    export TERM=xterm-256color
fi
