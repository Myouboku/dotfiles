#
# ~/.bashrc
#

# Need to stay at the top of the file
[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='\u@\h | \d - \A\n>>> \w : '

# Aliases
alias ls='ls --color=auto'
alias la='ls -la --color=auto'
alias grep='grep --color=auto'
alias cu='checkupdates && yay -Qua'
alias v='vim'
alias e='exit'
alias c='clear'
alias p='pwd'

# Sources
source /usr/share/doc/pkgfile/command-not-found.bash

# Execs
eval "$(zoxide init bash)"
eval $(thefuck --alias fuck)
. /opt/asdf-vm/asdf.sh

# Need to stay at the end of the file
[[ ${BLE_VERSION-} ]] && ble-attach
