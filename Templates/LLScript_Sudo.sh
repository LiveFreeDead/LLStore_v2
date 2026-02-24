#!/bin/bash

#LLStore Sudo Script v1.02

#---------- User Set Variables ----------

# Set to true to reinstall packages even if already installed (useful for fixing broken installs)
FORCE_REINSTALL=false

################################################################################
#                                                                              #
#  Sections until next block are functions that the user does not need to edit #
#                                                                              #
################################################################################

#---------- Initialization ----------

echo "Initializing Sudo-Level Script..."
echo

# Prompt for sudo credentials up front to avoid mid-script interruptions
sudo -v

# Keep sudo credentials alive in background while script runs.
# The background process is registered with a trap so it's always cleaned up on exit.
( while true; do sudo -n true; sleep 55; done ) &
SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT INT TERM

#---------- Functions ----------

# Install native packages using whatever package manager is detected.
# Usage: inst package1 package2 ...
# Cache is checked first (fast local lookup) to skip unavailable packages.
# Each valid package is installed individually so one failure never blocks the rest.
inst () {
    if [[ -z "$PM_CMD" ]]; then
        echo "Error: No supported package manager found. Cannot install: $*"
        return 1
    fi

    for PKG in "$@"; do
        # Check local cache - fast, no network required
        local AVAILABLE=false
        case "$PM" in
            apt)
                apt-cache show "$PKG" &>/dev/null && AVAILABLE=true
                ;;
            dnf|yum)
                dnf repoquery --quiet "$PKG" 2>/dev/null | grep -q . && AVAILABLE=true
                ;;
            pacman|pamac)
                pacman -Si "$PKG" &>/dev/null && AVAILABLE=true
                ;;
            zypper)
                zypper info "$PKG" &>/dev/null && AVAILABLE=true
                ;;
            emerge)
                emerge --search "$PKG" &>/dev/null && AVAILABLE=true
                ;;
            eopkg)
                eopkg info "$PKG" &>/dev/null && AVAILABLE=true
                ;;
            apk)
                apk info "$PKG" &>/dev/null && AVAILABLE=true
                ;;
            *)
                AVAILABLE=true
                ;;
        esac

        # Skip silently if not found in cache
        $AVAILABLE || continue

        # Skip if already installed - avoids PM startup overhead entirely
        # Set FORCE_REINSTALL=true at the top of the script to bypass this
        local INSTALLED=false
        case "$PM" in
            apt)
                dpkg-query -W -f='${Status}' "$PKG" 2>/dev/null | grep -q "install ok installed" && INSTALLED=true
                ;;
            dnf|yum)
                rpm -q "$PKG" &>/dev/null && INSTALLED=true
                ;;
            pacman|pamac)
                pacman -Q "$PKG" &>/dev/null && INSTALLED=true
                ;;
            zypper)
                rpm -q "$PKG" &>/dev/null && INSTALLED=true
                ;;
            eopkg)
                eopkg info --installed "$PKG" &>/dev/null && INSTALLED=true
                ;;
            apk)
                apk info -e "$PKG" &>/dev/null && INSTALLED=true
                ;;
        esac
        if $INSTALLED; then
            $FORCE_REINSTALL || { echo "Already installed: $PKG"; continue; }
            echo "Reinstalling: $PKG"
        else
            echo "Installing: $PKG"
        fi

        local OK=false
        case "$PM" in
            pamac)
                if $FORCE_REINSTALL && $INSTALLED; then
                    sudo "$PM_CMD" reinstall --no-confirm "$PKG" &>/dev/null && OK=true
                else
                    sudo "$PM_CMD" install --no-confirm "$PKG" &>/dev/null && OK=true
                fi
                ;;
            dnf|yum)
                if $FORCE_REINSTALL && $INSTALLED; then
                    sudo "$PM_CMD" -y reinstall "$PKG" &>/dev/null && OK=true
                else
                    sudo "$PM_CMD" -y install "$PKG" &>/dev/null && OK=true
                fi
                ;;
            apt)
                if $FORCE_REINSTALL && $INSTALLED; then
                    sudo "$PM_CMD" -y install --reinstall "$PKG" &>/dev/null && OK=true
                else
                    sudo "$PM_CMD" -y install "$PKG" &>/dev/null && OK=true
                fi
                sudo apt-mark manual "$PKG" &>/dev/null
                ;;
            pacman)
                # pacman -S --needed skips if current; drop --needed when reinstalling
                if $FORCE_REINSTALL && $INSTALLED; then
                    yes | sudo "$PM_CMD" -S --noconfirm "$PKG" &>/dev/null && OK=true
                else
                    yes | sudo "$PM_CMD" -S --needed --noconfirm "$PKG" &>/dev/null && OK=true
                fi
                ;;
            zypper)
                if $FORCE_REINSTALL && $INSTALLED; then
                    sudo "$PM_CMD" --non-interactive install --force "$PKG" &>/dev/null && OK=true
                else
                    sudo "$PM_CMD" --non-interactive install "$PKG" &>/dev/null && OK=true
                fi
                ;;
            emerge)
                sudo "$PM_CMD" "$PKG" &>/dev/null && OK=true
                ;;
            eopkg)
                sudo "$PM_CMD" -y install "$PKG" &>/dev/null && OK=true
                ;;
            apk)
                sudo "$PM_CMD" add "$PKG" &>/dev/null && OK=true
                ;;
            *)
                sudo "$PM_CMD" install "$PKG" &>/dev/null && OK=true
                ;;
        esac
        $OK && echo "OK: $PKG" || echo "Failed: $PKG"
    done
}

# Install Flatpaks system-wide.
# Usage: flatinst org.name.app1 org.name.app2 ...
flatinst () {
    # Install flatpak itself if missing, then re-check
    if ! command -v flatpak &>/dev/null; then
        echo "Flatpak not found. Attempting to install via native package manager..."
        inst flatpak
        if ! command -v flatpak &>/dev/null; then
            echo "Error: Flatpak could not be installed. System Flatpak install skipped."
            return 1
        fi
    fi

    # Silently add Flathub system repo if not already present
    if ! sudo flatpak remote-list 2>/dev/null | grep -q "flathub"; then
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &>/dev/null || true
    fi

    # Iterate over all supplied package IDs
    for PKG in "$@"; do
        # Skip if already installed system-wide
        if sudo flatpak info "$PKG" &>/dev/null; then
            echo "Flatpak (system) already installed, skipping: $PKG"
            continue
        fi
        echo "Installing System Flatpak: $PKG"

        # Write command to a temp script to avoid all quoting/pipe issues with -e / bash -c
        TMPSCRIPT=$(mktemp /tmp/flatinst_XXXXXX.sh)
        cat > "$TMPSCRIPT" << FLATSCRIPT
#!/bin/bash
yes 1 2>/dev/null | sudo flatpak install --system -y --noninteractive --assumeyes flathub "$PKG"
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

# Get Best Terminal (used for any GUI-launched terminal tasks added below)
TERMS=(gnome-terminal konsole xfce4-terminal x-terminal-emulator xterm)
OSTERM=""
for t in "${TERMS[@]}"; do
    if command -v "$t" &>/dev/null; then
        OSTERM="$t"
        break
    fi
done

# Detect Package Manager.
# command -v returns exactly one path (or nothing) - safe single-line assignment.
PM=""
PM_CMD=""
if PM_CMD=$(command -v pamac 2>/dev/null); then
    PM="pamac"
elif PM_CMD=$(command -v dnf 2>/dev/null); then
    PM="dnf"
elif PM_CMD=$(command -v apt 2>/dev/null); then
    PM="apt"
elif PM_CMD=$(command -v pacman 2>/dev/null); then
    PM="pacman"
elif PM_CMD=$(command -v zypper 2>/dev/null); then
    PM="zypper"
elif PM_CMD=$(command -v yum 2>/dev/null); then
    PM="yum"
elif PM_CMD=$(command -v emerge 2>/dev/null); then
    PM="emerge"
elif PM_CMD=$(command -v eopkg 2>/dev/null); then
    PM="eopkg"
elif PM_CMD=$(command -v apk 2>/dev/null); then
    PM="apk"
fi

# Detect OS
. /etc/os-release

# Detect Desktop Environment with fallback chain.
# XDG_SESSION_DESKTOP is often missing under sudo even with -E, attempt to get from the /tmp file
# then we try multiple variables and finally process detection before giving up.

# Try to read saved desktop environment first (from non-sudo context)
DE=""
DE_ENV_FILE="/tmp/LLDesktopEnv.ini"
if [[ -f "$DE_ENV_FILE" ]]; then
    echo "Loading data from LLDesktopEnv.ini"
    # Read the saved environment
    while IFS='=' read -r key value; do
        [[ "$key" == "XDG_SESSION_DESKTOP" ]] && DE="$value"
        [[ "$key" == "XDG_CURRENT_DESKTOP" ]] && [[ -z "$DE" ]] && DE="$value"
        [[ "$key" == "DESKTOP_SESSION" ]] && [[ -z "$DE" ]] && DE="$value"
        [[ "$key" == "GDMSESSION" ]] && [[ -z "$DE" ]] && DE="$value"
    done < "$DE_ENV_FILE"
fi

if [[ -z "$DE" ]]; then
    DE="${XDG_SESSION_DESKTOP:-}"
fi
if [[ -z "$DE" ]]; then
    DE="${XDG_CURRENT_DESKTOP:-}"       # e.g. X-Cinnamon, GNOME, KDE
fi
if [[ -z "$DE" ]]; then
    DE="${DESKTOP_SESSION:-}"            # e.g. cinnamon, plasma, gnome
fi
if [[ -z "$DE" ]]; then
    DE="${GDMSESSION:-}"                 # GDM fallback
fi
if [[ -z "$DE" ]]; then
    # Last resort: check running DE processes
    for proc in cinnamon gnome-shell plasmashell xfce4-session mate-session lxsession lxqt-session budgie-wm; do
        if pgrep -x "$proc" &>/dev/null; then
            DE="$proc"
            break
        fi
    done
fi
# Normalise: strip leading "X-", take first entry if colon-separated (e.g. "GNOME:GNOME")
DE="${DE#X-}"
DE="${DE%%:*}"


########## Output System Details ##########
echo
echo -e "\033[1;4m            System Details            \033[0m"
echo "Package Manager: ${PM:-"None found"} (${PM_CMD:-"N/A"})"
echo "Terminal Used:   ${OSTERM:-"None found"}"
echo "Desktop:         ${DE:-"Not detected"}"
echo "OS ID:           $ID"

# Refresh package manager cache if missing or older than 24 hours
case "$PM" in
    pamac|pacman)
        if [[ $(find /var/lib/pacman/sync -name "*.db" -mmin -1440 2>/dev/null | wc -l) -eq 0 ]]; then
            echo "Updating package cache..."
            sudo pacman -Sy --noconfirm &>/dev/null
        fi
        ;;
    dnf)
        if [[ $(find /var/cache/dnf -name "*.solv" -mmin -1440 2>/dev/null | wc -l) -eq 0 ]]; then
            echo "Updating package cache..."
            sudo dnf makecache --quiet &>/dev/null
        fi
        ;;
    apt)
        if [[ $(find /var/lib/apt/lists -name "*_Packages" -mmin -1440 2>/dev/null | wc -l) -eq 0 ]]; then
            echo "Updating package cache..."
            sudo apt-get update -qq &>/dev/null
        fi
        ;;
    zypper)
        if [[ $(find /var/cache/zypp/solv -name "*.solv" -mmin -1440 2>/dev/null | wc -l) -eq 0 ]]; then
            echo "Updating package cache..."
            sudo zypper --quiet refresh &>/dev/null
        fi
        ;;
    yum)
        if [[ $(find /var/cache/yum -name "repomd.xml" -mmin -1440 2>/dev/null | wc -l) -eq 0 ]]; then
            echo "Updating package cache..."
            sudo yum makecache --quiet &>/dev/null
        fi
        ;;
    emerge)
        if [[ $(find /var/cache/eix -name "portage.eix" -mmin -1440 2>/dev/null | wc -l) -eq 0 ]]; then
            echo "Updating package cache..."
            sudo emerge --sync &>/dev/null
        fi
        ;;
    eopkg)
        if [[ $(find /var/lib/eopkg/index -name "*.xml.bz2" -mmin -1440 2>/dev/null | wc -l) -eq 0 ]]; then
            echo "Updating package cache..."
            sudo eopkg update-repo &>/dev/null
        fi
        ;;
    apk)
        if [[ $(find /var/cache/apk -name "APKINDEX*" -mmin -1440 2>/dev/null | wc -l) -eq 0 ]]; then
            echo "Updating package cache..."
            sudo apk update &>/dev/null
        fi
        ;;
esac

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
