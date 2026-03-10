#!/bin/bash

set -e

echo "→ Git pull"
git pull

MAIN=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
if [ -z "$MAIN" ]; then
    MAIN=$(git remote show origin 2>/dev/null | grep 'HEAD' | awk '{print $NF}')
fi

CURRENT=$(git branch --show-current)

if [ "$CURRENT" != "$MAIN" ] && [ -n "$MAIN" ]; then
    read -p "Merger $MAIN dans $CURRENT ? [y/N] " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        echo "→ Merge..."
        if ! git merge --no-edit "origin/$MAIN"; then
            echo "✗ Conflicts detected"
            exit 1
        fi
        echo "✓ Merge OK"
    else
        echo "→ Skip merge"
    fi
else
    echo "→ Already on $MAIN"
fi

echo "→ npm install"
npm install

echo "✓ Done"
