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

if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
    exec tmux new-session -A -s "${USER}" >/dev/null 2>&1
fi
