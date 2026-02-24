#!/bin/bash

#LLStore Script v1.01

################################################################################
#                                                                              #
#  Sections until next block are functions that the user does not need to edit #
#                                                                              #
################################################################################

#---------- Initialization ----------

echo "Initializing User-Level Script..."
echo

#---------- Functions ----------

# Install Flatpaks for the CURRENT USER only (no sudo required)
# Usage: flatinst org.name.app1 org.name.app2 ...
flatinst () {
    # Verify flatpak is available
    if ! command -v flatpak &>/dev/null; then
        echo "Error: Flatpak is not installed. User Flatpak install skipped."
        return 1
    fi

    # Ensure user-level flatpak bin directory is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/share/flatpak/exports/bin:"* ]]; then
        export PATH="$PATH:$HOME/.local/share/flatpak/exports/bin"
    fi

    # Silently add Flathub if not already present
    if ! flatpak remotes --user 2>/dev/null | grep -q "flathub"; then
        flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &>/dev/null || true
    fi

    # Iterate over all supplied package IDs
    for PKG in "$@"; do
        # Skip if already installed
        if flatpak info --user "$PKG" &>/dev/null; then
            echo "Flatpak (user) already installed, skipping: $PKG"
            continue
        fi
        echo "Installing User Flatpak: $PKG"

        # Write command to a temp script to avoid all quoting/pipe issues with -e / bash -c
        TMPSCRIPT=$(mktemp /tmp/flatinst_XXXXXX.sh)
        cat > "$TMPSCRIPT" << FLATSCRIPT
#!/bin/bash
yes 1 2>/dev/null | flatpak install --user -y --noninteractive --assumeyes flathub "$PKG"
FLATSCRIPT
        chmod +x "$TMPSCRIPT"

        # Spawn a terminal window and WAIT for it to finish before continuing
        case "$OSTERM" in
            gnome-terminal)
                "$OSTERM" --wait -- bash "$TMPSCRIPT"
                ;;
            konsole)
                "$OSTERM" -e bash "$TMPSCRIPT"
                ;;
            *)
                # xfce4-terminal, x-terminal-emulator, xterm all block naturally with -e
                "$OSTERM" -e bash "$TMPSCRIPT"
                ;;
        esac

        rm -f "$TMPSCRIPT"
    done
}

#---------- System Detection ----------

# Get Best Terminal (used for any user-launched terminal tasks added below)
TERMS=(gnome-terminal konsole xfce4-terminal x-terminal-emulator xterm)
OSTERM=""
for t in "${TERMS[@]}"; do
    if command -v "$t" &>/dev/null; then
        OSTERM="$t"
        break
    fi
done

# Detect OS
. /etc/os-release

echo
echo -e "\033[1;4m            System Details            \033[0m"
echo "Terminal Used:   ${OSTERM:-"None found"}"
echo "Desktop:         $XDG_SESSION_DESKTOP"
echo "OS ID:           $ID"

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
