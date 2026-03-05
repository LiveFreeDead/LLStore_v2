#!/bin/bash
# =============================================================================
# LLStore setup.sh  -  Bootstrap Installer
# -----------------------------------------------------------------------------
# - Detects desktop environment and package manager (mirrors LLScript_Sudo_Core)
# - Installs the best available terminal for the current DE if none is found
# - Creates lastos-users group and adds user to it
# - Uses 'sg' to activate the new group IN THIS SESSION so llstore -setup never
#   needs to be run twice due to a missing group on first boot (Mint, fresh KDE, etc.)
# - Applies gnome-terminal Wayland theme fix when relevant
# =============================================================================

# ---------------------------------------------------------------------------
# Resolve script location so relative paths always work, even when called
# from a different directory.
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

TOOLS="$SCRIPT_DIR/Tools"

# ---------------------------------------------------------------------------
# Helper: print a section header
# ---------------------------------------------------------------------------
header() { echo; echo "==> $*"; }

# ---------------------------------------------------------------------------
# 1. Detect Desktop Environment
#    XDG vars can be unset under sudo; read them from the user env first,
#    then fall back to process inspection.
# ---------------------------------------------------------------------------
header "Detecting desktop environment..."

REAL_USER="${SUDO_USER:-$USER}"
DE="${XDG_SESSION_DESKTOP:-}"
[[ -z "$DE" ]] && DE="${XDG_CURRENT_DESKTOP:-}"
[[ -z "$DE" ]] && DE="${DESKTOP_SESSION:-}"
[[ -z "$DE" ]] && DE="${GDMSESSION:-}"
if [[ -z "$DE" ]]; then
    for proc in cinnamon gnome-shell plasmashell xfce4-session mate-session \
                lxsession lxqt-session budgie-wm; do
        if pgrep -x "$proc" &>/dev/null; then DE="$proc"; break; fi
    done
fi
DE="${DE#X-}"        # strip leading "X-"
DE="${DE%%:*}"       # take first entry if colon-separated
DE="${DE,,}"         # lowercase

SESSION_TYPE="${XDG_SESSION_TYPE:-x11}"
SESSION_TYPE="${SESSION_TYPE,,}"

echo "Desktop:      ${DE:-unknown}"
echo "Session type: $SESSION_TYPE"
echo "Real user:    $REAL_USER"

# ---------------------------------------------------------------------------
# 2. Detect Package Manager (same priority order as LLScript_Sudo_Core.sh)
# ---------------------------------------------------------------------------
header "Detecting package manager..."

PM=""
PM_CMD=""
if   PM_CMD=$(command -v pamac  2>/dev/null); then PM="pamac"
elif PM_CMD=$(command -v dnf    2>/dev/null); then PM="dnf"
elif PM_CMD=$(command -v apt    2>/dev/null); then PM="apt"
elif PM_CMD=$(command -v pacman 2>/dev/null); then PM="pacman"
elif PM_CMD=$(command -v zypper 2>/dev/null); then PM="zypper"
elif PM_CMD=$(command -v yum    2>/dev/null); then PM="yum"
elif PM_CMD=$(command -v emerge 2>/dev/null); then PM="emerge"
elif PM_CMD=$(command -v eopkg  2>/dev/null); then PM="eopkg"
elif PM_CMD=$(command -v apk    2>/dev/null); then PM="apk"
fi

echo "Package manager: ${PM:-none} (${PM_CMD:-N/A})"

# ---------------------------------------------------------------------------
# 3. Package install helper (runs via sudo_script.sh for privilege escalation)
#    Mirrors the logic from LLScript_Sudo_Core.sh inst() but user-space safe.
# ---------------------------------------------------------------------------
install_pkg() {
    local PKG="$1"
    echo "Installing: $PKG"
    case "$PM" in
        pamac)  "$TOOLS/sudo_script.sh" "$PM_CMD" install --no-confirm "$PKG" ;;
        dnf)    "$TOOLS/sudo_script.sh" "$PM_CMD" -y install "$PKG" ;;
        apt)    "$TOOLS/sudo_script.sh" "$PM_CMD" -y install "$PKG" ;;
        pacman) yes | "$TOOLS/sudo_script.sh" "$PM_CMD" -S --noconfirm "$PKG" ;;
        zypper) "$TOOLS/sudo_script.sh" "$PM_CMD" --non-interactive install "$PKG" ;;
        yum)    "$TOOLS/sudo_script.sh" "$PM_CMD" -y install "$PKG" ;;
        emerge) "$TOOLS/sudo_script.sh" "$PM_CMD" "$PKG" ;;
        eopkg)  "$TOOLS/sudo_script.sh" "$PM_CMD" -y install "$PKG" ;;
        apk)    "$TOOLS/sudo_script.sh" "$PM_CMD" add "$PKG" ;;
        *)      echo "Error: No supported package manager found. Cannot install $PKG"; return 1 ;;
    esac
}

# Check if a package is available in the repo (avoids wasted install attempts)
pkg_available() {
    local PKG="$1"
    case "$PM" in
        apt)            apt-cache show "$PKG" &>/dev/null ;;
        dnf|yum)        "$PM_CMD" repoquery --quiet "$PKG" 2>/dev/null | grep -q . ;;
        pacman|pamac)   pacman -Si "$PKG" &>/dev/null ;;
        zypper)         zypper info "$PKG" &>/dev/null ;;
        eopkg)          eopkg info "$PKG" &>/dev/null ;;
        apk)            apk info "$PKG" &>/dev/null ;;
        *)              return 0 ;;   # assume available for unknown PMs
    esac
}

# ---------------------------------------------------------------------------
# 4. Terminal Detection
#    Same priority order as the updated DefaultTerminal.sh.
# ---------------------------------------------------------------------------
header "Detecting terminal emulator..."

TERMINALS=(
    ptyxis            # GNOME default (Ubuntu 24.10+ / Fedora 41+)
    gnome-terminal    # GNOME classic
    konsole           # KDE Plasma
    xfce4-terminal    # XFCE
    mate-terminal     # MATE
    lxterminal        # LXDE
    qterminal         # LXQt
    tilix             # Popular tiling terminal
    terminator        # Popular multi-pane terminal
    alacritty         # GPU-accelerated
    kitty             # GPU-accelerated
    foot              # Wayland-native
    x-terminal-emulator  # Debian/Ubuntu alternatives symlink
    xterm             # Universal fallback
)

SYS_TERMINAL=""
for t in "${TERMINALS[@]}"; do
    if command -v "$t" &>/dev/null; then
        SYS_TERMINAL="$t"
        break
    fi
done

echo "Detected terminal: ${SYS_TERMINAL:-none found}"

# ---------------------------------------------------------------------------
# 5. Install a terminal if none was found
#    Pick the best candidate for the detected DE rather than always forcing
#    gnome-terminal onto KDE/XFCE/etc. users.
# ---------------------------------------------------------------------------
if [[ -z "$SYS_TERMINAL" ]] && [[ -n "$PM" ]]; then
    header "No terminal found — installing one for your desktop..."

    # Map DE → preferred terminal package name
    case "$DE" in
        plasma*|kde*)
            TERM_PKG="konsole" ;;
        xfce*)
            TERM_PKG="xfce4-terminal" ;;
        mate*)
            TERM_PKG="mate-terminal" ;;
        lxde*)
            TERM_PKG="lxterminal" ;;
        lxqt*)
            TERM_PKG="qterminal" ;;
        cinnamon*)
            # Cinnamon ships on Mint which is Debian/Ubuntu-based
            TERM_PKG="gnome-terminal" ;;
        *)
            # GNOME, Unity, Budgie, unknown — gnome-terminal is the safest default
            TERM_PKG="gnome-terminal" ;;
    esac

    echo "Preferred terminal for DE '$DE': $TERM_PKG"

    if pkg_available "$TERM_PKG"; then
        install_pkg "$TERM_PKG"
    else
        # Fallback: try xterm as a last resort — it's in every repo
        echo "Note: $TERM_PKG not available in repo, trying xterm as fallback..."
        install_pkg "xterm"
        TERM_PKG="xterm"
    fi

    # Re-detect after install
    if command -v "$TERM_PKG" &>/dev/null; then
        SYS_TERMINAL="$TERM_PKG"
        echo "Terminal installed: $SYS_TERMINAL"
    else
        echo "Warning: Terminal install may not have completed. llstore will attempt anyway."
    fi

elif [[ -z "$SYS_TERMINAL" ]]; then
    echo "Warning: No terminal found and no package manager available to install one."
fi

# ---------------------------------------------------------------------------
# 6. gnome-terminal Wayland theme fix
#    Only apply when gnome-terminal is actually the active terminal AND
#    we are on a Wayland session — avoids touching gsettings unnecessarily.
# ---------------------------------------------------------------------------
if [[ "$SYS_TERMINAL" == "gnome-terminal" ]] && [[ "$SESSION_TYPE" == "wayland" ]]; then
    header "Applying gnome-terminal Wayland theme fix..."
    if command -v gsettings &>/dev/null; then
        PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default 2>/dev/null || true)
        if [[ -n "$PROFILE" ]]; then
            PROFILE="${PROFILE:1:-1}"  # strip surrounding single quotes
            PKEY="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${PROFILE}/"
            gsettings set "$PKEY" use-theme-colors    'false'                  2>/dev/null || true
            gsettings set "$PKEY" foreground-color    'rgb(208,207,204)'       2>/dev/null || true
            gsettings set "$PKEY" background-color    'rgb(23,20,33)'          2>/dev/null || true
            echo "Wayland theme fix applied to profile: $PROFILE"
        else
            echo "Note: Could not read gnome-terminal default profile — skipping theme fix."
        fi
    else
        echo "Note: gsettings not found — skipping gnome-terminal Wayland theme fix."
    fi
fi

# ---------------------------------------------------------------------------
# 7. Desktop shortcuts
#    Copy .desktop files so distros that skip llstore's own installer step
#    still get working menu entries.
# ---------------------------------------------------------------------------
header "Installing desktop shortcuts..."
mkdir -p "$HOME/.local/share/applications"
cp -f "$TOOLS"/*.desktop "$HOME/.local/share/applications/" 2>/dev/null || true
echo "Done."

# ---------------------------------------------------------------------------
# 8. lastos-users group
#    Run setup_lastos_group.sh (which calls usermod internally via sudo).
#    After that we use 'sg' to make llstore -setup run with the group ACTIVE
#    in this very session — no logout required, no need to run setup twice.
# ---------------------------------------------------------------------------
header "Configuring lastos-users group..."

"$TOOLS/sudo_script.sh" "$TOOLS/setup_lastos_group.sh"

# Verify the group now exists on this system
if getent group lastos-users &>/dev/null; then
    # Check if the user is already in the group in the current session.
    # If not (freshly added), 'sg' launches a sub-shell that has it.
    if id -nG "$REAL_USER" 2>/dev/null | grep -qw "lastos-users"; then
        GROUP_ACTIVE=true
    else
        GROUP_ACTIVE=false
    fi
    echo "lastos-users group active in this session: $GROUP_ACTIVE"
else
    echo "Warning: lastos-users group could not be confirmed — continuing anyway."
    GROUP_ACTIVE=true  # let llstore deal with it
fi

# ---------------------------------------------------------------------------
# 9. Launch llstore -setup
#    If the group was just added this session (GROUP_ACTIVE=false), wrap the
#    launch in 'sg lastos-users' so the process inherits the group immediately.
#    This is what prevents the "run it twice" problem on Mint and fresh installs.
# ---------------------------------------------------------------------------
header "Launching llstore -setup..."

# Build the launch command. On Wayland with non-Wayland-native apps, keep the
# GDK_BACKEND=x11 override that was in the original script.
if [[ "$SESSION_TYPE" == "wayland" ]]; then
    LAUNCH_CMD="env GDK_BACKEND=x11 \"$SCRIPT_DIR/llstore\" -setup"
else
    LAUNCH_CMD="\"$SCRIPT_DIR/llstore\" -setup"
fi

if [[ "$GROUP_ACTIVE" == "false" ]] && getent group lastos-users &>/dev/null; then
    echo "Note: lastos-users was just added to your account."
    echo "      Launching llstore inside the new group via 'sg' — no re-login needed."
    sg lastos-users -c "cd \"$SCRIPT_DIR\" && $LAUNCH_CMD"
else
    eval "$LAUNCH_CMD"
fi

echo
echo "==> setup.sh complete."
