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

OPTIONS=""
while IFS= read -r vpn; do
    if [ "$vpn" = "$ACTIVE_VPN" ]; then
        OPTIONS="$OPTIONS✓ $vpn\n"
    else
        OPTIONS="$OPTIONS  $vpn\n"
    fi
done <<<"$VPNS"

SELECTED=$(echo -e "$OPTIONS" | rofi -dmenu -p "VPN:" -no-custom | sed 's/^[✓ ]* //')
if [ -n "$SELECTED" ]; then
    if [ "$SELECTED" = "$ACTIVE_VPN" ]; then
        nmcli connection down "$SELECTED"
    else
        nmcli connection up "$SELECTED"
    fi
fi
