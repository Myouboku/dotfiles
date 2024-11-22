function unitstatus() {
    local unit
    unit=$(systemctl list-units --no-pager --plain | fzf | awk '{print $1}')

    if [[ -n "$unit" ]]; then
        systemctl status "$unit"
    fi
}
