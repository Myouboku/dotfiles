# Setup

## Requirements

Everything for a base installation of Hyprland on Arch with dotfiles ready.
AUR helper is required.

```bash
yay -S --needed stow pkgfile blesh zoxide thefuck vim git github-cli mangohud hyprland xdg-desktop-portal-hyprland kitty wofi waybar dolphin asdf-vm vim-gruvbox-git firefox spotify discord 1password pipewire pipewire-pulse pipewire-audio hyprpaper
```

## Packages configurations

- Bash
- Vim
- Git
- MangoHud
- Hyprland
- Wofi
- Waybar
- Kitty
- Hyprpaper

## Creating symlinks

```bash
git clone https://github.com/Myouboku/dotfiles.git
cd dotfiles
stow .
```
