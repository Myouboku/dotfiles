# Installation

1. Install [Arch Linux](https://archlinux.org/download/)
2. Install [HyDE (hyprdots)](https://github.com/prasanthrangan/hyprdots?tab=readme-ov-file#installation)
3. Install the following packages
   ```bash
   yay -S --needed stow yazi neovim lazygit zoxide thefuck fzf bat flatpak zen-browser-avx2-bin ripgrep fd delta
   ```
4. Get the dotfiles
   ```bash
   cd ~
   git clone https://github.com/Myouboku/dotfiles.git
   cd dotfiles
   stow .
   ```
