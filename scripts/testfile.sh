#!/usr/bin/env bash

set -euo pipefail

if [ "$(basename "$PWD")" != "srv" ]; then
    cd "srv" || exit 1
fi

NODE_NO_WARNINGS=1 npm run pretest:api

args=()
for arg in "$@"; do
    if [[ "$arg" == srv/* ]]; then
        arg="${arg#srv/}"
    elif [[ "$arg" == srv ]]; then
        arg="."
    fi
    args+=("$arg")
done

NODE_NO_WARNINGS=1 npx mocha "${args[@]}"
