#!/bin/bash

#LLStore Sudo Script v1.03

#---------- User Set Variables ----------

# Set to true to reinstall packages even if already installed (useful for fixing broken installs)
FORCE_REINSTALL=false

################################################################################
#                                                                              #
#  Sections until next block are functions that the user does not need to edit #
#                                                                              #
################################################################################

#---------- Sudo Keepalive ----------

# Prompt for sudo credentials up front to avoid mid-script interruptions
sudo -v

# Keep sudo credentials alive in background while script runs.
# The background process is registered with a trap so it's always cleaned up on exit.
( while true; do sudo -n true; sleep 55; done ) &
SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT INT TERM

# Source shared core: inst, flatinst, terminal/PM/DE detection, system details.
# Tries the installed path first so manual script runs always get a core.
# Falls back to %ToolPath%/ (USB/portable path, replaced at install time by LLStore).
if [ -f "%ToolPath%/LLScript_Sudo_Core.sh" ]; then source "%ToolPath%/LLScript_Sudo_Core.sh"; elif [ -f "/LastOS/LLStore/Tools/LLScript_Sudo_Core.sh" ]; then source "/LastOS/LLStore/Tools/LLScript_Sudo_Core.sh"; fi #LLCore

################################################################################
#                                                                              #
#    Sections below are where you edit with your code that will run in order   #
#                                                                              #
################################################################################

#---------- Package Manager Tasks ----------
echo
echo -e "\033[4m        Package Manager Tasks         \033[0m"
case "$PM" in
    pamac)
        # Arch/Manjaro package names differ from rpm/deb - add pamac-specific packages here
        ;;

    dnf)
        ;;

    apt)
        ;;

    pacman)
        # Arch package names differ from rpm/deb - add pacman-specific packages here
        ;;

    zypper)
        ;;

    yum)
        ;;

    emerge)
        ;;

    eopkg)
        ;;

    apk)
        ;;

    *)
        ;;
esac

#---------- OS Specific Tasks ----------
echo
echo -e "\033[4m          OS Specific Tasks           \033[0m"
# Add per-distro repo setup, PPAs, etc. here before inst() calls below.
case "$ID" in
    manjaro)
        ;;

    linuxmint|ubuntu)
        ;;

    debian|pop)
        ;;

    fedora|nobara)
        ;;

    opensuse-tumbleweed)
        ;;

    almalinux)
        ;;

    arch|endeavouros)
        ;;

    argent)
        ;;

    biglinux)
        ;;

    cachyos)
        ;;

    deepin)
        ;;

    garuda)
        ;;

    regataos)
        ;;

    solus)
        ;;

    zorin)
        ;;

    *)
        echo "Unknown Distribution ($ID). Script section skipped"
        ;;
esac

#---------- DE Specific Tasks ----------
echo
echo -e "\033[4m          DE Specific Tasks           \033[0m"
case "$DE" in
    *[Cc]innamon*)
        ;;

    gnome|ubuntu|ubuntu-xorg)
        ;;

    kde|KDE|plasma)
        ;;

    lxde)
        ;;

    mate|lightdm-xsession)
        ;;

    unity)
        ;;

    xfce)
        ;;

    [Cc][Oo][Ss][Mm][Ii][Cc]*|pop)
        ;;

    budgie-desktop)
        ;;

    LXQt)
        ;;

    anduinos|anduinos-xorg)
        ;;

    deepin)
        ;;

    default) #SUSE
        ;;

    zorin)
        ;;

    *)
        echo "Unknown Desktop Environment ($DE). Script section skipped"
        ;;
esac

#---------- Installation Section ----------
echo
echo -e "\033[4m         Installation Section         \033[0m"

# Native packages (uses detected package manager):
# inst appname1 appname2

# System-wide Flatpaks:
# flatinst org.name.app1 org.name.app2


echo
echo -e "\033[4m             Custom Code              \033[0m"
#----- Add Your Code Here ------


exit 0
