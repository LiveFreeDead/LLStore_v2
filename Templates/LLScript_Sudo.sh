#!/bin/bash

#---------- Functions ----------
inst () {
APT_CMD=$(type -P apt 2>/dev/null)
DNF_CMD=$(type -P dnf 2>/dev/null)
EMERGE_CMD=$(type -P emerge 2>/dev/null)
EOPKG_CMD=$(type -P eopkg 2>/dev/null)
APK_CMD=$(type -P apk 2>/dev/null)
PACMAN_CMD=$(type -P pacman 2>/dev/null)
ZYPPER_CMD=$(type -P zypper 2>/dev/null)
YUM_CMD=$(type -P yum 2>/dev/null)

if [[ ! -z $DNF_CMD ]]; then
    sudo $DNF_CMD -y install $*
elif [[ ! -z $APT_CMD ]]; then
    sudo $APT_CMD -y install $*
elif [[ ! -z $EMERGE_CMD ]]; then
    sudo $EMERGE_CMD $PACKAGES
elif [[ ! -z $EOPKG_CMD ]]; then
    sudo $EOPKG_CMD -y install $*
elif [[ ! -z $APK_CMD ]]; then
    sudo $APK_CMD add install $*
elif [[ ! -z $PACMAN_CMD ]]; then
    # Syu gets dependancies etc
    yes | sudo $PACMAN_CMD -Syu $*
elif [[ ! -z $ZYPPER_CMD ]]; then
    sudo $ZYPPER_CMD --non-interactive install $*
elif [[ ! -z $YUM_CMD ]]; then
    sudo $YUM_CMD -y install $*
else
    echo "error can't install package $*"
fi
}
#-------------------------------

#Get Best Terminal For LLStore (in order)
TERMS=(gnome-terminal konsole x-terminal-emulator xterm xfce4-terminal)
for t in ${TERMS[*]}
do
    if [ $(command -v $t) ]
    then
        OSTERM=$t
        break
    fi
done

#Get Package Manager
APT_CMD=$(type -P apt 2>/dev/null)
DNF_CMD=$(type -P dnf 2>/dev/null)
EMERGE_CMD=$(type -P emerge 2>/dev/null)
EOPKG_CMD=$(type -P eopkg 2>/dev/null)
APK_CMD=$(type -P apk 2>/dev/null)
PACMAN_CMD=$(type -P pacman 2>/dev/null)
ZYPPER_CMD=$(type -P zypper 2>/dev/null)
YUM_CMD=$(type -P yum 2>/dev/null)

#Get Desktop Environment to do tasks
echo "Terminal Used: $OSTERM"
echo "Desktop Environment: $XDG_SESSION_DESKTOP"

#-------------------------------

#Use below sections to put update/upgrade repository or add PPA or repo's
PM=""
if [[ ! -z $DNF_CMD ]]; then #dnf
    PM=dnf
    echo "Package Manager: dnf"
elif [[ ! -z $APT_CMD ]]; then #apt
    PM=apt
    echo "Package Manager: apt"
elif [[ ! -z $EMERGE_CMD ]]; then #emerge
    PM=emerge
    echo "Package Manager: emerge"
elif [[ ! -z $EOPKG_CMD ]]; then #eopkg
    PM=eopkg
    echo "Package Manager: eopkg"
elif [[ ! -z $APK_CMD ]]; then #apk
    PM=apk
    echo "Package Manager: apk"
elif [[ ! -z $PACMAN_CMD ]]; then #pacman
    PM=pacman
    echo "Package Manager: pacman"
elif [[ ! -z $ZYPPER_CMD ]]; then #zypper
    PM=zypper
    echo "Package Manager: zypper"
elif [[ ! -z $YUM_CMD ]]; then #yum
    PM=yum
    echo "Package Manager: yum"
else
    echo "Unknown Package Manager. Script section skipped"
fi


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


#Install Apps - using Inst function to work on many Distro's if the package(s) are available on its repositories.
#inst appname1 appname2 etc


#FlatPak Install Package System Wide (User mode should be done in non Sudo LLScript)
#Add "org.name.thing" to end of line in quote below and unremark to install a Flatpak
#$OSTERM -e "flatpak install --system -y --noninteractive flathub "


#----- Add Your Code Here ------


