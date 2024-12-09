#! /bin/bash

# Reformat the flatpak output to a table
formatToTable() {
    (echo -e "Name\tApplication ID\tVersion\tBranch\tArch"; cat "$1") |
    sed 's/\t/;/g' |
    column -s ';' -t
}

# List all available updates through pacman, the AUR and flatpak
Color_Off='\033[0m'       # Text Reset
Yellow='\033[1;93m'     # Yellow
Blue='\033[1;94m'       # Blue
Purple='\033[1;95m'     # Purple
Red='\033[1;91m'        # Red

pacmanFile=$(mktemp -t pacman.XXXXXXXX)
aurFile=$(mktemp -t aur.XXXXXXXX)
flatpakFile=$(mktemp -t flatpak.XXXXXXXX)

printf "\e${Yellow}%s\e${Color_Off}\n" "$(figlet Pacman)"
checkupdates | tee "$pacmanFile"

nbPac=$(wc -l < "$pacmanFile")
printf "\e${Yellow}\n%s\e${Color_Off}\n" "Available updates : ${nbPac}"

printf "\e${Blue}%s\e${Color_Off}\n" "$(figlet AUR)"
yay -Qua --color=always | tee "$aurFile"

nbAur=$(wc -l < "$aurFile")
printf "\e${Blue}\n%s\e${Color_Off}\n" "Available updates : ${nbAur}"

printf "\e${Purple}%s\e${Color_Off}\n" "$(figlet Flatpak)"
flatpak remote-ls --updates > "$flatpakFile"
formatToTable "$flatpakFile"

nbFlatpak=$(wc -l < "$flatpakFile")
printf "\e${Purple}\n%s\e${Color_Off}\n" "Available updates : ${nbFlatpak}"

nbTotal=$(echo "$nbPac+$nbAur+$nbFlatpak" | bc)
printf "\e${Red}\n%s\e${Color_Off}\n" "Total available updates : ${nbTotal}"
