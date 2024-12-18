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
