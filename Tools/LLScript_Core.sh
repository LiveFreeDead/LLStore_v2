#!/bin/bash

#LLStore Core v1.00 - User Level
# Sourced by LLScript.sh at install time.
# DO NOT add user-specific install logic here.

#---------- Initialization ----------

echo "Initializing User-Level Script..."
echo

#---------- Functions ----------

# Install Flatpaks for the CURRENT USER only (no sudo required)
# Usage: flatinst org.name.app1 org.name.app2 ...
flatinst () {
    if ! command -v flatpak &>/dev/null; then
        echo "Error: Flatpak is not installed. User Flatpak install skipped."
        return 1
    fi

    if [[ ":$PATH:" != *":$HOME/.local/share/flatpak/exports/bin:"* ]]; then
        export PATH="$PATH:$HOME/.local/share/flatpak/exports/bin"
    fi

    if ! flatpak remotes --user 2>/dev/null | grep -q "flathub"; then
        flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &>/dev/null || true
    fi

    for PKG in "$@"; do
        if flatpak info --user "$PKG" &>/dev/null; then
            echo "Flatpak (user) already installed, skipping: $PKG"
            continue
        fi
        echo "Installing User Flatpak: $PKG"

        TMPSCRIPT=$(mktemp /tmp/flatinst_XXXXXX.sh)
        cat > "$TMPSCRIPT" << FLATSCRIPT
#!/bin/bash
yes 1 2>/dev/null | flatpak install --user -y --noninteractive --assumeyes flathub "$PKG"
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

# Detect OS
. /etc/os-release

echo
echo -e "\033[1;4m            System Details            \033[0m"
echo "Terminal Used:   ${OSTERM:-"None found"}"
echo "Desktop:         ${XDG_SESSION_DESKTOP:-"Not detected"}"
echo "OS ID:           $ID"
