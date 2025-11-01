#!/usr/bin/env bash
# Usage: focus_or_launch.sh <class_regex> <launch_cmd>

CLASS_REGEX="$1"
LAUNCH_CMD="$2"

clients_json="$(hyprctl -j clients 2>/dev/null)"
if [ -z "$clients_json" ]; then
    exec bash -lc "$LAUNCH_CMD"
fi

match_addr=$(echo "$clients_json" | jq -r --arg re "$CLASS_REGEX" '
  .[] | select(.class? and (.class | test($re))) | .address
' | head -n1)

if [ -n "$match_addr" ]; then
    hyprctl dispatch focuswindow address:"$match_addr"
else
    bash -lc "$LAUNCH_CMD" &
fi
