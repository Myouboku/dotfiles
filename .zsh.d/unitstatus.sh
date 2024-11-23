function unitstatus() {
    local unit
    unit=$(systemctl list-unit-files --no-pager --plain | sed '1d' | fzf --layout=reverse | awk '{print $1}')

    if [[ -n "$unit" ]]; then
        systemctl status "$unit"
    fi
}
