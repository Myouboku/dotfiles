#!/bin/bash

VPNS=$(nmcli -t -f NAME,TYPE connection show | grep vpn | cut -d: -f1)
ACTIVE=$(nmcli -t connection show --active | grep -oE "^[^:]+")

ACTIVE_VPN=""
for vpn in $VPNS; do
    if echo "$ACTIVE" | grep -q "^$vpn$"; then
        ACTIVE_VPN="$vpn"
        break
    fi
done

if [ -z "$ACTIVE_VPN" ]; then
    echo "Off"
else
    echo "$ACTIVE_VPN"
fi
