alias c='clear'
alias lg='lazygit'
alias port-forwarding="\$HOME/scripts/port_forwarding.sh"
alias unitstatus="\$HOME/scripts/unitstatus.sh"
alias cu="\$HOME/scripts/checkupdates.sh"
alias wt="source \$HOME/scripts/git_worktree.sh"
alias up="flatpak update && yay"
alias devm='NODE_ENV=development nodemon -e js,cjs,mjs,sql src/index.js'
alias dev='NODE_ENV=development node src/index.js'
alias testapi='NODE_ENV=test npm run pretest:api && (cd srv && NODE_ENV=test npx mocha --parallel --exit)'
alias test='NODE_ENV=test npx mocha --parallel --exit'
alias bright='systemctl --user restart plasma-powerdevil.service'
alias ncdu="ncdu --color dark"
alias s="kitten ssh"
