# Reformat the flatpak output to a table
function formatToTable() {
    (echo -e "Name\tApplication ID\tVersion\tBranch\tArch"; cat "$1") |
    sed 's/\t/;/g' |
    column -s ';' -t
}

# List all available updates through pacman, the AUR and flatpak
function cu() {
    pacmanFile="/tmp/pacmanUpdates.txt"
    aurFile="/tmp/aurUpdates.txt"
    flatpakFile="/tmp/flatpakUpdates.txt"

    echo -e "${BIYellow}$(figlet Pacman)${Color_Off}\n"
    checkupdates | tee $pacmanFile
    echo -e "\n${BIYellow}Available updates : $(cat $pacmanFile | wc -l)${Color_Off}"

    echo -e "${BIBlue}$(figlet AUR)${Color_Off}\n"
    yay -Qua --color=always | tee $aurFile
    echo -e "\n${BIBlue}Available updates : $(cat $aurFile | wc -l)${Color_Off}"

    echo -e "${BIPurple}$(figlet Flatpak)${Color_Off}\n"
    flatpak remote-ls --updates > $flatpakFile
    formatToTable $flatpakFile
    echo -e "\n${BIPurple}Available updates : $(cat $flatpakFile | wc -l)${Color_Off}"

    echo -e "\n${IRed}Total available updates : $(cat $pacmanFile $aurFile $flatpakFile | wc -l)${Color_Off}"
}
