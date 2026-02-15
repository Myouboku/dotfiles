#!/bin/bash

HEADSET_INFOS=$(solaar show "Headset" 2>/dev/null)
BATTERY_LINE=$(echo "$HEADSET_INFOS" | grep "Battery" | head -1)
STATUS=$(echo "$BATTERY_LINE" | awk '{print $2}')

echo "Headset battery: $STATUS"
