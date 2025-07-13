#!/bin/bash

IS_GNOMETERMINAL=$(type -P gnome-terminal)

if [[ -z $IS_GNOMETERMINAL ]]; then

PACKAGES=gnome-terminal

APT_CMD=$(type -P apt 2>/dev/null)
DNF_CMD=$(type -P dnf 2>/dev/null)
EMERGE_CMD=$(type -P emerge 2>/dev/null)
EOPKG_CMD=$(type -P eopkg 2>/dev/null)
APK_CMD=$(type -P apk 2>/dev/null)
PACMAN_CMD=$(type -P pacman 2>/dev/null)
PAMAC_CMD=$(type -P pamac 2>/dev/null)
ZYPPER_CMD=$(type -P zypper 2>/dev/null)
YUM_CMD=$(type -P yum 2>/dev/null)

if [[ ! -z $PAMAC_CMD ]]; then
    ./Tools/sudo_script.sh $PAMAC_CMD install --no-confirm $PACKAGES
elif [[ ! -z $DNF_CMD ]]; then
    ./Tools/sudo_script.sh $DNF_CMD -y install $PACKAGES
elif [[ ! -z $APT_CMD ]]; then
    ./Tools/sudo_script.sh $APT_CMD -y install $PACKAGES
elif [[ ! -z $EMERGE_CMD ]]; then
    ./Tools/sudo_script.sh $EMERGE_CMD $PACKAGES
elif [[ ! -z $EOPKG_CMD ]]; then
    ./Tools/sudo_script.sh $EOPKG_CMD -y install $PACKAGES
elif [[ ! -z $APK_CMD ]]; then
    ./Tools/sudo_script.sh $APK_CMD add install $PACKAGES
elif [[ ! -z $PACMAN_CMD ]]; then
    yes | ./Tools/sudo_script.sh $PACMAN_CMD -S $PACKAGES
elif [[ ! -z $ZYPPER_CMD ]]; then
    ./Tools/sudo_script.sh $ZYPPER_CMD --non-interactive install $PACKAGES
elif [[ ! -z $YUM_CMD ]]; then
    ./Tools/sudo_script.sh $YUM_CMD -y install $PACKAGES
else
    echo "error can't install package $PACKAGES"
fi

#Fix gnome terminal theme on Wayland
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    profile=$(gsettings get org.gnome.Terminal.ProfilesList default)
    profile=${profile:1:-1} # remove leading and trailing single quotes

    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-theme-colors 'false'

    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ foreground-color 'rgb(208,207,204)'

    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ background-color 'rgb(23,20,33)'
fi  #Wayland check

fi  #Top gnome check

#Allow SELinux Security in SUSE and Fedora to install it - Disabled due to each item installed requiring you to allow it, so SELinux OS's won't work

#./Tools/sudo_script.sh setenforce 0

##./Tools/sudo_script.sh execstack -c "./llstore Libs/XojoGUIFramework64.so"
##./Tools/sudo_script.sh execstack -c "./llstore Libs/*"


#Copy .dektop files for Distro's that wont create them within the llstore installer (just in case)
mkdir -p $HOME/.local/share/applications
cp -f ./Tools/*.desktop $HOME/.local/share/applications


#Run LLStore to install the rest (requires gnome terminal to get sudo properly, konsole works but most others will error out unless you pick to run this script in terminal)
env GDK_BACKEND=x11 ./llstore -setup

