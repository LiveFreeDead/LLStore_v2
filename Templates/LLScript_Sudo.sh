#!/bin/bash

#=============================================================================
#  UNIVERSAL INSTALLER, UPDATER & CLEANER (SUDO)
#=============================================================================

#---------- Functions ----------

# Helper: Run command with sudo if not root
run_priv() {
    if [ "$EUID" -ne 0 ]; then
        if command -v sudo >/dev/null 2>&1; then
            sudo "$@"
        else
            echo "Error: This command requires root privileges but sudo is missing."
            exit 1
        fi
    else
        "$@"
    fi
}

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

# INSTALL Function
inst() {
    # Detect Package Managers in order of preference
    if command -v pamac >/dev/null 2>&1; then
        run_priv pamac install --no-confirm "$@"
    elif command -v dnf >/dev/null 2>&1; then
        # --setopt=strict=0 prevents removing packages to satisfy new ones
        run_priv dnf install -y --setopt=strict=0 "$@"
    elif command -v apt >/dev/null 2>&1; then
        # --no-remove stops apt from uninstalling existing packages (like Wine)
        run_priv apt install -y --no-remove "$@"
    elif command -v pacman >/dev/null 2>&1; then
        run_priv pacman -S --noconfirm --needed "$@"
    elif command -v zypper >/dev/null 2>&1; then
        run_priv zypper install -n "$@"
    elif command -v apk >/dev/null 2>&1; then
        run_priv apk add "$@"
    elif command -v xbps-install >/dev/null 2>&1; then
        run_priv xbps-install -y "$@"
    elif command -v eopkg >/dev/null 2>&1; then
        run_priv eopkg install -y "$@"
    elif command -v swupd >/dev/null 2>&1; then
        run_priv swupd bundle-add -y "$@"
    elif command -v emerge >/dev/null 2>&1; then
        # --noreplace prevents re-installing or overwriting existing atoms
        run_priv emerge --noreplace "$@"
    elif command -v slackpkg >/dev/null 2>&1; then
        run_priv slackpkg install "$@"
    elif command -v yum >/dev/null 2>&1; then
        run_priv yum install -y "$@"
    else
        echo "Error: No supported package manager found to install $*"
    fi
}

# UPDATE REPOSITORIES Function
upd() {
    echo "Updating repository lists..."
    if command -v apt >/dev/null 2>&1; then run_priv apt update
    elif command -v dnf >/dev/null 2>&1; then run_priv dnf check-update
    elif command -v pacman >/dev/null 2>&1; then run_priv pacman -Sy
    elif command -v zypper >/dev/null 2>&1; then run_priv zypper refresh
    elif command -v apk >/dev/null 2>&1; then run_priv apk update
    elif command -v xbps-install >/dev/null 2>&1; then run_priv xbps-install -S
    elif command -v eopkg >/dev/null 2>&1; then run_priv eopkg update-repo
    elif command -v swupd >/dev/null 2>&1; then run_priv swupd update
    else echo "Update not supported or manager not found."
    fi
}

# CLEAN SYSTEM Function (Removes orphans/cache)
cln() {
    echo "Cleaning up unneeded packages and cache..."
    if command -v apt >/dev/null 2>&1; then 
        run_priv apt autoremove -y && run_priv apt autoclean
    elif command -v dnf >/dev/null 2>&1; then 
        run_priv dnf autoremove -y && run_priv dnf clean all
    elif command -v pacman >/dev/null 2>&1; then 
        # Check for orphans first to avoid errors if the list is empty
        ORPHANS=$(pacman -Qdtq)
        if [ -n "$ORPHANS" ]; then
            run_priv pacman -Rns $ORPHANS --noconfirm
        else
            echo "No orphans to clean."
        fi
        run_priv pacman -Scc --noconfirm
    elif command -v zypper >/dev/null 2>&1; then 
        run_priv zypper clean --all
    elif command -v apk >/dev/null 2>&1; then 
        run_priv apk cache clean
    elif command -v xbps-remove >/dev/null 2>&1; then 
        run_priv xbps-remove -Oo
    elif command -v eopkg >/dev/null 2>&1; then 
        run_priv eopkg delete-cache
    fi
}

#-------------------------------

#---------- Detection ----------

# 1. Get Best Terminal (Expanded List)
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

# 2. Get Desktop Environment (Robust Check)
# First try standard env vars
CURRENT_DE=${XDG_CURRENT_DESKTOP:-$XDG_SESSION_DESKTOP}

# If empty (common in sudo), check running processes or sessions
if [ -z "$CURRENT_DE" ]; then
    if pgrep -x "gnome-session" > /dev/null; then CURRENT_DE="gnome"
    elif pgrep -x "mate-session" > /dev/null; then CURRENT_DE="mate"
    elif pgrep -x "xfce4-session" > /dev/null; then CURRENT_DE="xfce"
    elif pgrep -x "plasma-desktop" > /dev/null || pgrep -x "plasmashell" > /dev/null; then CURRENT_DE="kde"
    elif pgrep -x "cinnamon" > /dev/null; then CURRENT_DE="cinnamon"
    elif pgrep -x "lxqt-session" > /dev/null; then CURRENT_DE="lxqt"
    elif pgrep -x "budgie-desktop" > /dev/null; then CURRENT_DE="budgie"
    fi
fi

# Final fallback: Check the login manager records if available
if [ -z "$CURRENT_DE" ] && [ -n "$SUDO_USER" ]; then
    CURRENT_DE=$(sudo -u "$SUDO_USER" printenv XDG_CURRENT_DESKTOP)
fi

echo "----------------------------------------"
echo "Terminal Detected:  $OSTERM"
echo " Desktop Detected:  $CURRENT_DE"

# 3. Detect Package Manager & Set Variable
PM=""
if command -v pamac >/dev/null 2>&1; then PM="pamac"
elif command -v dnf >/dev/null 2>&1; then PM="dnf"
elif command -v apt >/dev/null 2>&1; then PM="apt"
elif command -v pacman >/dev/null 2>&1; then PM="pacman"
elif command -v zypper >/dev/null 2>&1; then PM="zypper"
elif command -v apk >/dev/null 2>&1; then PM="apk"
elif command -v xbps-install >/dev/null 2>&1; then PM="xbps"
elif command -v swupd >/dev/null 2>&1; then PM="swupd"
elif command -v eopkg >/dev/null 2>&1; then PM="eopkg"
elif command -v emerge >/dev/null 2>&1; then PM="emerge"
elif command -v yum >/dev/null 2>&1; then PM="yum"
elif command -v slackpkg >/dev/null 2>&1; then PM="slackpkg"
fi

if [ -z "$PM" ]; then
    echo "Warning: No standard package manager detected."
else
    echo "  Package Manager:  $PM"
fi


# 4. OS Specific Logic
if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    ID="unknown"
fi

echo "   OS ID Detected:  $ID"
echo "----------------------------------------"

case $ID in
    ubuntu|linuxmint|debian|pop|kali|parrot|elementary)
        ;;
    fedora|nobara|rhel|centos|almalinux|rocky)
        ;;
    opensuse*|sles)
        ;;
    arch|endeavouros|manjaro|garuda)
        ;;
    void)
        ;;
    alpine)
        ;;
    gentoo)
        ;;
    solus)
        ;;
    clear-linux-os)
        ;;
    *)
        echo "Note: Specific distro logic skipped for '$ID'."
        ;;
esac


# 5. Desktop Environment Specific Logic
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
        echo "Note: Specific DE logic skipped for '$CURRENT_DE'."
        ;;
esac

#---------- User Customization Section ----------

# Example: Install common apps using the universal function
#---------- Execution Flow ----------
# Step 1: Update Repositories
#upd

# Step 2: Install your software
# inst git vlc curl

# Step 3: Clean up
#cln

# Example: Flatpak Install (System Wide)
# Ensure you uncomment the line below and add your app ID
#term_run "flatpak install --system -y --noninteractive flathub org.mozilla.firefox"

#----- Add Your Code Here ------
