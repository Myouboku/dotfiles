#! /bin/bash

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "Error : not in a git repo" >&2
    return 1
}

if [[ $# -ne 1 ]]; then
    echo "Usage : $0 <branch_name>" >&2
    return 1
fi

BRANCH=$1
REPO=$(basename "$ROOT")
PARENT=$(dirname "$ROOT")
WT="$PARENT/${REPO}-${BRANCH//\//-}"

if [[ -d $WT ]]; then
    cd "$WT"
    return 0
fi

cd "$ROOT"

IS_NEW_BRANCH=false
if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
    git worktree add "$WT" "$BRANCH"
elif git ls-remote --heads origin "$BRANCH" | grep -q "$BRANCH"; then
    git fetch origin "$BRANCH"
    git branch --track "$BRANCH" "origin/$BRANCH"
    git worktree add "$WT" "$BRANCH"
else
    IS_NEW_BRANCH=true
    git worktree add -b "$BRANCH" "$WT" HEAD
fi

if [[ $IS_NEW_BRANCH ]]; then
    echo "Do you want to make a new database for this branch ? [y/N] :"
    read -r NEW_BASE
    if [[ $NEW_BASE = "y" || $NEW_BASE = "Y" ]]; then
        DATAS="{ \"source\": \"development.fdb\", \"destination\": \"$BRANCH\" }"
        curl -X POST -H 'Content-Type: application/json' -d $DATAS http://192.168.10.51:1234/files/xplanet/duplicate
    fi
fi

CONFIG_DIR="$WT/srv/config/"
if [[ -d $CONFIG_DIR ]]; then
    mkdir -p $CONFIG_DIR

    cp "$ROOT/opencode.json" "$WT/opencode.json"
    cp "$ROOT/AGENTS.md" "$WT/AGENTS.md"

    cp -R "$ROOT/srv/config/." $CONFIG_DIR
    cd $CONFIG_DIR

    DEV_JSON="development.json"
    if [[ -f $DEV_JSON ]]; then
        sed -i "s|\.\./\.\./${REPO}|../../${REPO}-${BRANCH//\//-}|g" $DEV_JSON
        sed -i "s|- dev|- ${BRANCH}|g" $DEV_JSON

        if [[ $NEW_BASE = "y" || $NEW_BASE = "Y" ]]; then
            sed -i "s|DEVELOPMENT.fdb|${BRANCH//\//-}.fdb|gi" $DEV_JSON
        fi

        cd "$WT"

        npm install
        npm run generate:sqlrequests
        npm run pretest:api

        echo "Do you want to build front ? [y/N] :"
        read -r SENCHA_WATCH
        if [[ $SENCHA_WATCH == "y" || $SENCHA_WATCH == "Y" ]]; then
            sencha app watch | while read line; do
                echo "$line"
                if [[ "$line" == *"Waiting for changes"* ]]; then
                    pkill -f "sencha"
                    break
                fi
            done
        fi
    fi
fi
