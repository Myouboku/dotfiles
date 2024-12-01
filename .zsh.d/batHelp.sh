# bat help wrapper
help() {
    "$@" --help 2>&1 | bat --plain --language=help
}
