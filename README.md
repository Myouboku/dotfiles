# Setup

## Requirements

Everything for a base installation of Hyprland on Arch with dotfiles ready.
AUR helper is required.

```bash
yay -S --needed stow pkgfile zoxide thefuck vim git github-cli mangohud hyprland hyprpicker hyprpaper hyprshot xdg-desktop-portal-hyprland kitty wofi waybar dolphin asdf-vm vim-gruvbox-git firefox spotify discord 1password pipewire pipewire-pulse pipewire-audio wireplumber cliphist swaync wlogout btop qt6ct kvantum nwg-look starship bash-completion neovim ripgrep lazygit
```

NvChad must be installed for Neovim to work properly

## Packages configurations

- [Bash](https://www.gnu.org/software/bash/)
- [Git](https://git-scm.com/)
- [Hyprland](https://hyprland.org/)
- [Hyprpaper](https://github.com/hyprwm/hyprpaper)
- [Kitty](https://sw.kovidgoyal.net/kitty/)
- [MangoHud](https://github.com/flightlessmango/MangoHud)
- [Neovim](https://neovim.io/)
- [NvChad](https://nvchad.com/)
- [Starship](https://starship.rs/)
- [SwayNotificationCenter](https://github.com/ErikReider/SwayNotificationCenter)
- [Vim](https://www.vim.org/)
- [Waybar](https://github.com/Alexays/Waybar)
- [Wlogout](https://github.com/ArtsyMacaw/wlogout)
- [Wofi](https://hg.sr.ht/~scoopta/wofi)

## Theme used

[Catppuccin mocha](https://github.com/catppuccin/catppuccin)

![image](https://github.com/Myouboku/dotfiles/assets/71690611/a1536605-50cc-4ad3-b62e-025166c9d12f)

## Creating symlinks

```bash
git clone https://github.com/Myouboku/dotfiles.git
cd dotfiles
stow .
```
