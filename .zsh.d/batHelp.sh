# bat help wrapper
function help() {
    "$@" --help 2>&1 | bat --plain --language=help
}
