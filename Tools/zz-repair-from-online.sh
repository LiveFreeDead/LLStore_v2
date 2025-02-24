#!/bin/bash

#This script can repair or install LL Store using the latest available full package.

#Functions
inst () {
APT_CMD=$(which apt 2>/dev/null)
DNF_CMD=$(which dnf 2>/dev/null)
EMERGE_CMD=$(which emerge 2>/dev/null)
EOPKG_CMD=$(which eopkg 2>/dev/null)
APK_CMD=$(which apk 2>/dev/null)
PACMAN_CMD=$(which pacman 2>/dev/null)
ZYPPER_CMD=$(which zypper 2>/dev/null)
YUM_CMD=$(which yum 2>/dev/null)

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
    #yes | sudo $PACMAN_CMD -S $*
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

clear

echo "This may ask for sudo password if unzip, gnome-terminal or jq isn't installed."
echo ""

if [[ $(which unzip) ]]; then
echo "Found unzip."
else
inst unzip
fi

if [[ $(which gnome-terminal) ]]; then
echo "Found gnome-terminal."
else
inst gnome-terminal
fi

if [[ $(which jq) ]]; then
echo "Found jq."
else
inst jq
fi


cd /tmp

rm ./llstore_latest.zip
rm -rf ./LLUpdate

FILE=llstore_latest.zip     
wget -O $FILE -c "https://github.com/LiveFreeDead/LastOSLinux_Repository/raw/refs/heads/main/llstore_latest.zip"
unzip -o ./$FILE -d ./LLUpdate

cd LLUpdate

bash setup.sh

cd ..

rm -rf ./LLUpdate
rm ./llstore_latest.zip
