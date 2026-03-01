#!/bin/bash

GTK_DARK="Adwaita-dark"
GTK_LIGHT="Adwaita"
ICON_DARK="Papirus-Dark"
ICON_LIGHT="Papirus"

KV_DARK="KvGnomeDark"
KV_LIGHT="KvGnome"

QT_COLOR_DARK="darker"
QT_COLOR_LIGHT="airy"

CURRENT=$(gsettings get org.gnome.desktop.interface color-scheme)

set_dark() {
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_DARK"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface icon-theme "$ICON_DARK"

    kvantummanager --set "$KV_DARK" 2>/dev/null

    sed -i "s/^color_scheme_path=.*/color_scheme_path=\/usr\/share\/qt5ct\/colors\/${QT_COLOR_DARK}.conf/" \
        ~/.config/qt5ct/qt5ct.conf
    sed -i "s/^color_scheme_path=.*/color_scheme_path=\/usr\/share\/qt6ct\/colors\/${QT_COLOR_DARK}.conf/" \
        ~/.config/qt6ct/qt6ct.conf

    # notify-send "Theme" "Dark theme enabled" 2>/dev/null
    echo "dark"
}

set_light() {
    gsettings set org.gnome.desktop.interface gtk-theme "$GTK_LIGHT"
    gsettings set org.gnome.desktop.interface color-scheme 'default'
    gsettings set org.gnome.desktop.interface icon-theme "$ICON_LIGHT"

    kvantummanager --set "$KV_LIGHT" 2>/dev/null

    sed -i "s/^color_scheme_path=.*/color_scheme_path=\/usr\/share\/qt5ct\/colors\/${QT_COLOR_LIGHT}.conf/" \
        ~/.config/qt5ct/qt5ct.conf
    sed -i "s/^color_scheme_path=.*/color_scheme_path=\/usr\/share\/qt6ct\/colors\/${QT_COLOR_LIGHT}.conf/" \
        ~/.config/qt6ct/qt6ct.conf

    # notify-send "Theme" "Light theme enabled" 2>/dev/null
    echo "light"
}

if [[ "$CURRENT" != "'prefer-dark'" ]]; then
    set_dark
else
    set_light
fi
