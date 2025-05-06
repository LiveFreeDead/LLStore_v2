#!/bin/bash

#Get Best Terminal
terms=(gnome-terminal konsole x-terminal-emulator xterm xfce4-terminal)
for t in ${terms[*]}
do
    if [ $(command -v $t) ]
    then
        OSTERM=$t
        break
    fi
done


#Get Desktop Environment to do tasks
echo "Terminal Used: $OSTERM"
echo "Desktop Environment: $XDG_SESSION_DESKTOP"


#Do Tasks For Detected OS
. /etc/os-release

echo "OS ID: $ID"

case $ID in
  linuxmint|ubuntu) 
    ;;

  debian|pop)
    ;;

  fedora|nobara) 
    ;;

  opensuse-tumbleweed) 
    ;;

  arch|endeavouros)
    ;;

  biglinux)
    ;;

  solus)
    ;;

  *) 
    echo "Unknown Distribution. Script section skipped"
    ;;
esac


#Do Tasks For Active Desktop Environment
case $XDG_SESSION_DESKTOP in
  cinnamon)
    ;;

  gnome|ubuntu)
    ;;
  
  kde|KDE)
    ;;

  lxde)
    ;;

  mate)
    ;;
  
  unity)
    ;;

  xfce)
    ;;

  cosmic|pop)
    ;;

  budgie-desktop)
    ;;

  LXQt)
    ;;

  *)
    echo "Unknown Desktop Environment. Script section skipped"
    ;;
esac


#FlatPak Install Package for User
#Add "org.name.thing" to end of line in quote below and unremark to install a Flatpak
#$OSTERM -e "flatpak install --user -y --noninteractive flathub "


#----- Add Your Code Here ------


