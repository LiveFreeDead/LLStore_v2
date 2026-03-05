#!/bin/bash

# Repairs or fresh-installs LLStore using the latest package from GitHub.

# ---------------------------------------------------------------------------
# Package install helper (mirrors LLScript_Sudo_Core.sh priority order)
# ---------------------------------------------------------------------------
inst() {
    local PM_CMD PM
    if   PM_CMD=$(command -v pamac  2>/dev/null); then PM="pamac"
    elif PM_CMD=$(command -v dnf    2>/dev/null); then PM="dnf"
    elif PM_CMD=$(command -v apt    2>/dev/null); then PM="apt"
    elif PM_CMD=$(command -v pacman 2>/dev/null); then PM="pacman"
    elif PM_CMD=$(command -v zypper 2>/dev/null); then PM="zypper"
    elif PM_CMD=$(command -v yum    2>/dev/null); then PM="yum"
    elif PM_CMD=$(command -v emerge 2>/dev/null); then PM="emerge"
    elif PM_CMD=$(command -v eopkg  2>/dev/null); then PM="eopkg"
    elif PM_CMD=$(command -v apk    2>/dev/null); then PM="apk"
    else echo "Error: no supported package manager found. Cannot install: $*"; return 1; fi

    for PKG in "$@"; do
        echo "Installing: $PKG"
        case "$PM" in
            pamac)  sudo "$PM_CMD" install --no-confirm "$PKG" ;;
            dnf)    sudo "$PM_CMD" -y install "$PKG" ;;
            apt)    sudo "$PM_CMD" -y install "$PKG" ;;
            pacman) yes | sudo "$PM_CMD" -S --noconfirm "$PKG" ;;
            zypper) sudo "$PM_CMD" --non-interactive install "$PKG" ;;
            yum)    sudo "$PM_CMD" -y install "$PKG" ;;
            emerge) sudo "$PM_CMD" "$PKG" ;;
            eopkg)  sudo "$PM_CMD" -y install "$PKG" ;;
            apk)    sudo "$PM_CMD" add "$PKG" ;;
        esac
    done
}

clear

echo "This may ask for your sudo password if unzip, jq or a terminal isn't installed."
echo ""

# ---------------------------------------------------------------------------
# Required tools
# ---------------------------------------------------------------------------
command -v unzip &>/dev/null && echo "Found unzip." || inst unzip
command -v jq    &>/dev/null && echo "Found jq."    || inst jq

# ---------------------------------------------------------------------------
# Terminal detection — same list as DefaultTerminal.sh
# ---------------------------------------------------------------------------
TERMINALS=(ptyxis gnome-terminal konsole xfce4-terminal mate-terminal
           lxterminal qterminal tilix terminator alacritty kitty foot
           x-terminal-emulator xterm)

SYS_TERMINAL=""
for t in "${TERMINALS[@]}"; do
    command -v "$t" &>/dev/null && SYS_TERMINAL="$t" && break
done

if [[ -z "$SYS_TERMINAL" ]]; then
    echo "No terminal emulator found — installing one..."
    # Pick best terminal for the detected DE, fall back to gnome-terminal
    DE="${XDG_SESSION_DESKTOP:-${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-}}}"
    DE="${DE,,}"
    case "$DE" in
        plasma*|kde*)  TERM_PKG="konsole" ;;
        xfce*)         TERM_PKG="xfce4-terminal" ;;
        mate*)         TERM_PKG="mate-terminal" ;;
        lxde*)         TERM_PKG="lxterminal" ;;
        lxqt*)         TERM_PKG="qterminal" ;;
        *)             TERM_PKG="gnome-terminal" ;;
    esac
    inst "$TERM_PKG"
    command -v "$TERM_PKG" &>/dev/null && SYS_TERMINAL="$TERM_PKG" \
        || { echo "Warning: terminal install may not have completed."; }
else
    echo "Found terminal: $SYS_TERMINAL"
fi

# ---------------------------------------------------------------------------
# Download and run the latest LLStore
# ---------------------------------------------------------------------------
cd /tmp

rm -f ./llstore_latest.zip
rm -rf ./LLUpdate

FILE=llstore_latest.zip
wget -O "$FILE" -c "https://github.com/LiveFreeDead/LastOSLinux_Repository/raw/refs/heads/main/llstore_latest.zip"
unzip -o "./$FILE" -d ./LLUpdate

cd LLUpdate
bash setup.sh
cd ..

rm -rf ./LLUpdate
rm -f ./llstore_latest.zip

