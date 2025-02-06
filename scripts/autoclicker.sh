#!/bin/bash

# Chemin vers le fichier de contrôle
CONTROL_FILE="/tmp/autoclicker_running"

# Fonction pour arrêter l'autoclicker
stop_autoclicker() {
    rm -f "$CONTROL_FILE"
    exit 0
}

# Vérifier si l'autoclicker est déjà en cours d'exécution
if [ -f "$CONTROL_FILE" ]; then
    stop_autoclicker
else
    # Créer le fichier de contrôle
    touch "$CONTROL_FILE"

    # Boucle d'autoclick
    while [ -f "$CONTROL_FILE" ]; do
        YDOTOOL_SOCKET="$HOME/.ydotool_socket" ydotool click 0xC0
        sleep 0.1
    done
fi
