#!/bin/bash

#=============================================================================
#  USER-LEVEL SETUP & DETECTOR SCRIPT (NON-SUDO)
#=============================================================================

# 1. Get Best Terminal (Expanded List)
# Checks for high-performance/common terminals first
TERMS=(
    gnome-terminal
    konsole
    xfce4-terminal
    lxterminal
    mate-terminal
    alacritty
    kitty
    terminator
    tilix
    x-terminal-emulator
    urxvt
    rxvt
    st
    xterm
)

OSTERM=""
for t in "${TERMS[@]}"; do
    if command -v "$t" >/dev/null 2>&1; then
        OSTERM="$t"
        break
    fi
done

term_run() {
    local cmd="$1"
    case "$OSTERM" in
        gnome-terminal|alacritty|kitty|terminator|tilix)
            # Modern syntax: terminal -- command
            $OSTERM -- bash -c "$cmd" &
            ;;
        konsole|xfce4-terminal|lxterminal|mate-terminal|xterm|x-terminal-emulator)
            # Legacy syntax: terminal -e command
            $OSTERM -e bash -c "$cmd" &
            ;;
        *)
            # Fallback for unknown terminals
            $OSTERM -e "$cmd" &
            ;;
    esac
}

# 2. Get Desktop Environment (Robust Check)
# Checks XDG_SESSION_DESKTOP first, falls back to XDG_CURRENT_DESKTOP
CURRENT_DE=${XDG_SESSION_DESKTOP:-$XDG_CURRENT_DESKTOP}

echo "----------------------------------------"
echo "Terminal Detected:  $OSTERM"
echo " Desktop Detected:  $CURRENT_DE"


# 3. Do Tasks For Detected OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    ID="unknown"
fi

echo "   OS ID Detected:  $ID"

echo "----------------------------------------"

case $ID in
    ubuntu|linuxmint|debian|pop|kali|parrot|elementary)
        # Debian/Ubuntu based logic
        ;;

    fedora|nobara|rhel|centos|almalinux|rocky)
        # RPM/Fedora based logic
        ;;

    opensuse*|sles)
        # OpenSUSE logic
        ;;

    arch|endeavouros|manjaro|garuda)
        # Arch based logic
        ;;

    void)
        # Void Linux logic
        ;;

    alpine)
        # Alpine Linux logic
        ;;

    gentoo)
        # Gentoo logic
        ;;

    solus)
        # Solus logic
        ;;

    clear-linux-os)
        # Clear Linux logic
        ;;

    *)
        echo "Unknown Distribution ($ID). Script section skipped"
        ;;
esac


# 4. Do Tasks For Active Desktop Environment
# Normalized case statement to handle different naming conventions (e.g., KDE vs kde)
case "${CURRENT_DE,,}" in # "${VAR,,}" converts to lowercase for easier matching
    cinnamon|x-cinnamon)
        ;;

    gnome|ubuntu|ubuntu:gnome)
        ;;

    kde|plasma|kde-plasma)
        ;;

    xfce|xfce4)
        ;;

    mate)
        ;;

    lxqt)
        ;;

    lxde)
        ;;

    budgie-desktop|budgie)
        ;;

    pantheon) # Elementary OS
        ;;

    deepin)
        ;;

    i3)
        ;;

    sway)
        ;;

    hyprland)
        ;;

    cosmic|pop)
        ;;

    unity)
        ;;

    *)
        echo "Unknown Desktop Environment ($CURRENT_DE). Script section skipped"
        ;;
esac


# 5. Flatpak Install Package for User
# Since this is a non-sudo script, we use the '--user' flag.
# Add "org.name.thing" to end of line in quote below and unremark to install a Flatpak.
# The 'nohup' and '&' allow the terminal to close without killing the install process if needed.

# Example: Flatpak Install (User)
# Ensure you uncomment the line below and add your app ID
#term_run "flatpak install --user -y --noninteractive flathub org.mozilla.firefox"

#----- Add Your Code Here ------


