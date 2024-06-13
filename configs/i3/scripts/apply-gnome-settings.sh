#!/bin/bash

# Obtem o tema GTK
theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
echo "Tema GTK: $theme"

# Define o tema GTK no GNOME
gsettings set org.gnome.desktop.interface gtk-theme "$theme"

# Obtem o tema de ícones
icon_theme=$(gsettings get org.gnome.desktop.interface icon-theme)
echo "Tema de ícones: $icon_theme"

# Define o tema de ícones no GNOME
gsettings set org.gnome.desktop.interface icon-theme "$icon_theme"

# Obtem o tema do cursor
cursor_theme=$(gsettings get org.gnome.desktop.interface cursor-theme)
echo "Tema do cursor: $cursor_theme"

# Define o tema do cursor no GNOME
gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme"

# Define as variáveis de ambiente para aplicar o tema GTK no Nautilus e outros apps do GNOME
export GTK_THEME="$theme"
export XDG_CURRENT_DESKTOP=GNOME
