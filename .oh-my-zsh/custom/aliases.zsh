alias c='clear'

alias lg='lazygit'

alias mkdir='mkdir -p'

alias grep="grep --color=always"
alias grepi="grep -i --color=always"

alias port-forwarding="\$HOME/scripts/port_forwarding.sh"
alias unitstatus="\$HOME/scripts/unitstatus.sh"

alias cu="\$HOME/scripts/checkupdates.sh"
alias up="flatpak update && yay"

alias devm='NODE_ENV=development nodemon --inspect -e js,cjs,mjs,sql src/index.js'
alias dev='NODE_ENV=development node --inspect src/index.js'

alias testapi='NODE_ENV=test npm run pretest:api && npx mocha --parallel --exit'
alias test='NODE_ENV=test npx mocha --parallel --exit'

alias bright='systemctl --user restart plasma-powerdevil.service'
