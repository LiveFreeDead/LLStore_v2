#!/bin/bash

profile=$(gsettings get org.gnome.Terminal.ProfilesList default)
profile=${profile:1:-1} # remove leading and trailing single quotes

gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-theme-colors 'false'

gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ foreground-color 'rgb(208,207,204)'

gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ background-color 'rgb(23,20,33)'
