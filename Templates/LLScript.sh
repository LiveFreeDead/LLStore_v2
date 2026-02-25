#!/bin/bash

#LLStore Script v1.02

#---------- User Set Variables ----------

# (Add any variables your script needs here before the core loads)

################################################################################
#                                                                              #
#  Sections until next block are functions that the user does not need to edit #
#                                                                              #
################################################################################

# Source shared core: functions (flatinst), terminal/OS detection, system details.
# Tries the installed path first so manual script runs always get a core.
# Falls back to %ToolPath%/ (USB/portable path, replaced at install time by LLStore).
if [ -f "%ToolPath%/LLScript_Core.sh" ]; then source "%ToolPath%/LLScript_Core.sh"; elif [ -f "/LastOS/LLStore/Tools/LLScript_Core.sh" ]; then source "/LastOS/LLStore/Tools/LLScript_Core.sh"; fi #LLCore

################################################################################
#                                                                              #
#    Sections below are where you edit with your code that will run in order   #
#                                                                              #
################################################################################

#---------- OS Specific Tasks ----------
echo
echo -e "\033[4m          OS Specific Tasks           \033[0m"
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
case "$XDG_SESSION_DESKTOP" in
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
        echo "Unknown Desktop Environment ($XDG_SESSION_DESKTOP). Script section skipped"
        ;;
esac

#---------- Installation Section ----------
echo
echo -e "\033[4m         Installation Section         \033[0m"

# To install user Flatpaks (no sudo required):
# flatinst org.name.app1 org.name.app2

echo
echo -e "\033[4m             Custom Code              \033[0m"
#----- Add Your Code Here ------


exit 0
