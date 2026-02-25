#!/bin/bash

#LLStore Sudo Core v1.00 - Sudo Level
# Sourced by LLScript_Sudo.sh at install time.
# DO NOT add app-specific install logic here.

#---------- Defaults ----------

# FORCE_REINSTALL may be set by the calling script before sourcing this core.
# Default to false if not already set so old scripts that omit it still work.
FORCE_REINSTALL=${FORCE_REINSTALL:-false}

#---------- Initialization ----------

echo "Initializing Sudo-Level Script..."
echo

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

        $AVAILABLE || continue

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
    if ! command -v flatpak &>/dev/null; then
        echo "Flatpak not found. Attempting to install via native package manager..."
        inst flatpak
        if ! command -v flatpak &>/dev/null; then
            echo "Error: Flatpak could not be installed. System Flatpak install skipped."
            return 1
        fi
    fi

    if ! sudo flatpak remote-list 2>/dev/null | grep -q "flathub"; then
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &>/dev/null || true
    fi

    for PKG in "$@"; do
        if sudo flatpak info "$PKG" &>/dev/null; then
            echo "Flatpak (system) already installed, skipping: $PKG"
            continue
        fi
        echo "Installing System Flatpak: $PKG"

        TMPSCRIPT=$(mktemp /tmp/flatinst_XXXXXX.sh)
        cat > "$TMPSCRIPT" << FLATSCRIPT
#!/bin/bash
yes 1 2>/dev/null | sudo flatpak install --system -y --noninteractive --assumeyes flathub "$PKG"
FLATSCRIPT
        chmod +x "$TMPSCRIPT"

        case "$OSTERM" in
            gnome-terminal) "$OSTERM" --wait -- bash "$TMPSCRIPT" ;;
            konsole)        "$OSTERM" -e bash "$TMPSCRIPT" ;;
            *)              "$OSTERM" -e bash "$TMPSCRIPT" ;;
        esac

        rm -f "$TMPSCRIPT"
    done
}

#---------- System Detection ----------

# Get Best Terminal
TERMS=(gnome-terminal konsole xfce4-terminal x-terminal-emulator xterm)
OSTERM=""
for t in "${TERMS[@]}"; do
    if command -v "$t" &>/dev/null; then
        OSTERM="$t"
        break
    fi
done

# Detect Package Manager
PM=""
PM_CMD=""
if PM_CMD=$(command -v pamac 2>/dev/null);  then PM="pamac"
elif PM_CMD=$(command -v dnf 2>/dev/null);  then PM="dnf"
elif PM_CMD=$(command -v apt 2>/dev/null);  then PM="apt"
elif PM_CMD=$(command -v pacman 2>/dev/null); then PM="pacman"
elif PM_CMD=$(command -v zypper 2>/dev/null); then PM="zypper"
elif PM_CMD=$(command -v yum 2>/dev/null);  then PM="yum"
elif PM_CMD=$(command -v emerge 2>/dev/null); then PM="emerge"
elif PM_CMD=$(command -v eopkg 2>/dev/null); then PM="eopkg"
elif PM_CMD=$(command -v apk 2>/dev/null);  then PM="apk"
fi

# Detect OS
. /etc/os-release

# Detect Desktop Environment
# Under sudo, XDG_* vars are often stripped from the environment.
# LLStore writes them to $HOME/zLastOSRepository/LLDesktopEnv.ini before launching scripts.
DE=""
DE_ENV_FILE="$HOME/zLastOSRepository/LLDesktopEnv.ini"
if [[ -f "$DE_ENV_FILE" ]]; then
    echo "Loading data from ~/zLastOSRepository/LLDesktopEnv.ini"
    while IFS='=' read -r key value; do
        case "$key" in
            XDG_SESSION_DESKTOP) DE="$value" ; export XDG_SESSION_DESKTOP="$value" ;;
            XDG_CURRENT_DESKTOP) [[ -z "$DE" ]] && DE="$value" ; export XDG_CURRENT_DESKTOP="$value" ;;
            DESKTOP_SESSION)     [[ -z "$DE" ]] && DE="$value" ; export DESKTOP_SESSION="$value"     ;;
            GDMSESSION)          [[ -z "$DE" ]] && DE="$value" ; export GDMSESSION="$value"          ;;
        esac
    done < "$DE_ENV_FILE"
fi

# Fallback chain if ini didn't provide a DE
[[ -z "$DE" ]] && DE="${XDG_SESSION_DESKTOP:-}"
[[ -z "$DE" ]] && DE="${XDG_CURRENT_DESKTOP:-}"
[[ -z "$DE" ]] && DE="${DESKTOP_SESSION:-}"
[[ -z "$DE" ]] && DE="${GDMSESSION:-}"
if [[ -z "$DE" ]]; then
    for proc in cinnamon gnome-shell plasmashell xfce4-session mate-session lxsession lxqt-session budgie-wm; do
        if pgrep -x "$proc" &>/dev/null; then DE="$proc"; break; fi
    done
fi
# Normalise: strip leading "X-", take first entry if colon-separated
DE="${DE#X-}"
DE="${DE%%:*}"

# Output System Details
echo
echo -e "\033[1;4m            System Details            \033[0m"
echo "Package Manager: ${PM:-"None found"} (${PM_CMD:-"N/A"})"
echo "Terminal Used:   ${OSTERM:-"None found"}"
echo "Desktop:         ${DE:-"Not detected"}"
echo "OS ID:           $ID"

# Refresh package manager cache if missing or older than 24 hours
case "$PM" in
    pamac|pacman)
        if ! find /var/lib/pacman/sync -name "*.db" -mmin -1440 -print -quit 2>/dev/null | grep -q .; then
            echo "Updating package cache..."
            sudo pacman -Sy --noconfirm &>/dev/null
        fi
        ;;
    dnf)
        if ! find /var/cache/dnf -name "*.solv" -mmin -1440 -print -quit 2>/dev/null | grep -q .; then
            echo "Updating package cache..."
            sudo dnf makecache --quiet &>/dev/null
        fi
        ;;
    apt)
        if ! find /var/lib/apt/lists -name "*_Packages" -mmin -1440 -print -quit 2>/dev/null | grep -q .; then
            echo "Updating package cache..."
            sudo apt-get update -qq &>/dev/null
        fi
        ;;
    zypper)
        if ! find /var/cache/zypp/solv -name "*.solv" -mmin -1440 -print -quit 2>/dev/null | grep -q .; then
            echo "Updating package cache..."
            sudo zypper --quiet refresh &>/dev/null
        fi
        ;;
    yum)
        if ! find /var/cache/yum -name "repomd.xml" -mmin -1440 -print -quit 2>/dev/null | grep -q .; then
            echo "Updating package cache..."
            sudo yum makecache --quiet &>/dev/null
        fi
        ;;
    emerge)
        if ! find /var/cache/eix -name "portage.eix" -mmin -1440 -print -quit 2>/dev/null | grep -q .; then
            echo "Updating package cache..."
            sudo emerge --sync &>/dev/null
        fi
        ;;
    eopkg)
        if ! find /var/lib/eopkg/index -name "*.xml.bz2" -mmin -1440 -print -quit 2>/dev/null | grep -q .; then
            echo "Updating package cache..."
            sudo eopkg update-repo &>/dev/null
        fi
        ;;
    apk)
        if ! find /var/cache/apk -name "APKINDEX*" -mmin -1440 -print -quit 2>/dev/null | grep -q .; then
            echo "Updating package cache..."
            sudo apk update &>/dev/null
        fi
        ;;
esac
