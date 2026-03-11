#!/bin/bash
# =============================================================================
# LLStore setup.sh  -  Bootstrap Installer
# -----------------------------------------------------------------------------
# Runs a SINGLE sudo call that covers everything requiring root:
#   - terminal install (if needed)
#   - lastos-users group creation and user membership
#   - migration of /LastOS → /opt/LastOS with backward-compat symlink
#   - /opt/LastOS/Tools creation, ownership, permissions
#   - Uninstall.sh and UninstallLauncher.sh written and secured
# Then launches llstore -setup via 'sg lastos-users' so the new group is
# active in the session immediately — no re-login, no second run needed.
# =============================================================================

# Clear the variable that often auto-resets the title
unset PROMPT_COMMAND
printf '\033]0;LLStore Installer\007'

echo "Initializing Sudo-Level Script..."
echo

# =============================================================================
# Terminal self-spawn
# If this script has no interactive TTY (run from a file manager, .desktop
# launcher, or another script without a terminal), find a terminal emulator
# and re-launch inside it so sudo can prompt for a password and the user can
# see progress output.
# =============================================================================
if [[ ! -t 0 ]] || [[ ! -t 1 ]]; then
    SELF="$(realpath "${BASH_SOURCE[0]}")"
    SELF_DIR="$(dirname "$SELF")"
    for TERM_TRY in ptyxis gnome-terminal konsole xfce4-terminal mate-terminal \
                    lxterminal qterminal tilix terminator alacritty kitty foot \
                    x-terminal-emulator xterm; do
        if command -v "$TERM_TRY" &>/dev/null; then
            case "$TERM_TRY" in
                ptyxis|gnome-terminal|tilix|terminator|alacritty|kitty|foot)
                    exec "$TERM_TRY" -- bash "$SELF"
                    ;;
                xfce4-terminal|lxterminal|qterminal)
                    exec "$TERM_TRY" -e "bash \"$SELF\""
                    ;;
                konsole)
                    exec "$TERM_TRY" -e bash "$SELF"
                    ;;
                *)
                    exec "$TERM_TRY" -e bash "$SELF"
                    ;;
            esac
        fi
    done
    echo "ERROR: No terminal emulator found. Please open a terminal and run:"
    echo "  bash \"$SELF\""
    # On desktops with zenity/kdialog, show a visible error dialog
    if command -v zenity  &>/dev/null; then
        zenity --error --text="No terminal emulator found.\nPlease open a terminal and run setup.sh manually." 2>/dev/null &
    elif command -v kdialog &>/dev/null; then
        kdialog --error "No terminal emulator found.\nPlease open a terminal and run setup.sh manually." 2>/dev/null &
    fi
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"
TOOLS="$SCRIPT_DIR/Tools"

header() { echo; echo "==> $*"; }

# ---------------------------------------------------------------------------
# 1. Detect Desktop Environment
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
DE="${DE#X-}"
DE="${DE%%:*}"
DE="${DE,,}"

SESSION_TYPE="${XDG_SESSION_TYPE:-x11}"
SESSION_TYPE="${SESSION_TYPE,,}"

echo "Desktop:      ${DE:-unknown}"
echo "Session type: $SESSION_TYPE"
echo "Real user:    $REAL_USER"

# ---------------------------------------------------------------------------
# 2. Detect Package Manager
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
# 3. Detect terminal — decide if we need to install one before sudo
# ---------------------------------------------------------------------------
header "Detecting terminal emulator..."

TERMINALS=(
    ptyxis gnome-terminal konsole xfce4-terminal mate-terminal lxterminal
    qterminal tilix terminator alacritty kitty foot x-terminal-emulator xterm
)

SYS_TERMINAL=""
for t in "${TERMINALS[@]}"; do
    if command -v "$t" &>/dev/null; then
        SYS_TERMINAL="$t"
        break
    fi
done

echo "Detected terminal: ${SYS_TERMINAL:-none found}"

TERM_PKG=""
if [[ -z "$SYS_TERMINAL" ]] && [[ -n "$PM" ]]; then
    case "$DE" in
        plasma*|kde*)  TERM_PKG="konsole" ;;
        xfce*)         TERM_PKG="xfce4-terminal" ;;
        mate*)         TERM_PKG="mate-terminal" ;;
        lxde*)         TERM_PKG="lxterminal" ;;
        lxqt*)         TERM_PKG="qterminal" ;;
        *)             TERM_PKG="gnome-terminal" ;;
    esac
    echo "Will install terminal: $TERM_PKG"
fi

# ---------------------------------------------------------------------------
# 4. Build and run ONE sudo script covering everything elevated.
#
#    IMPORTANT: The variable assignments at the top use an unquoted heredoc so
#    that $REAL_USER, $TOOLS, $PM, $PM_CMD and $TERM_PKG are expanded NOW from
#    the setup.sh environment.  Everything after that uses a QUOTED heredoc
#    ('SUDO_BODY') so that $1, $@, $DESKTOP, ${TARGETS[@]} etc. inside the
#    embedded Uninstall.sh / UninstallLauncher.sh are written as literals and
#    not expanded prematurely.
# ---------------------------------------------------------------------------
header "Running setup (single sudo prompt)..."

SUDO_SCRIPT="$(mktemp /tmp/llstore_setup_XXXXXX.sh)"

# ── Part 1: variable header (unquoted — expands NOW) ────────────────────────
cat > "$SUDO_SCRIPT" << SUDO_HEADER
#!/bin/bash
set -e
REAL_USER="${REAL_USER}"
TOOLS="${TOOLS}"
PM="${PM}"
PM_CMD="${PM_CMD}"
TERM_PKG="${TERM_PKG}"
SUDO_HEADER

# ── Part 2: the rest of the script (quoted — no premature expansion) ─────────
cat >> "$SUDO_SCRIPT" << 'SUDO_BODY'

# ── Terminal install ─────────────────────────────────────────────────────────
if [[ -n "$TERM_PKG" ]]; then
    echo "Installing terminal: $TERM_PKG"
    case "$PM" in
        pamac)  "$PM_CMD" install --no-confirm "$TERM_PKG" ;;
        dnf)    "$PM_CMD" -y install "$TERM_PKG" ;;
        apt)    "$PM_CMD" -y install "$TERM_PKG" ;;
        pacman) "$PM_CMD" -S --needed --noconfirm "$TERM_PKG" ;;
        zypper) "$PM_CMD" --non-interactive install "$TERM_PKG" ;;
        yum)    "$PM_CMD" -y install "$TERM_PKG" ;;
        emerge) "$PM_CMD" "$TERM_PKG" ;;
        eopkg)  "$PM_CMD" -y install "$TERM_PKG" ;;
        apk)    "$PM_CMD" add "$TERM_PKG" ;;
    esac
fi

# ── lastos-users group + user membership ────────────────────────────────────
if [[ -f "$TOOLS/setup_lastos_group.sh" ]]; then
    bash "$TOOLS/setup_lastos_group.sh" /opt/LastOS
else
    groupadd --system lastos-users 2>/dev/null || true
    usermod -aG lastos-users "$REAL_USER" 2>/dev/null || true
    mkdir -p /opt/LastOS
    chown -R root:lastos-users /opt/LastOS
    chmod -R 775 /opt/LastOS
fi

# ── Migrate /LastOS → /opt/LastOS (if needed) and create symlink ─────────────
# On immutable distros (Bazzite etc.) / may not be writable - that's fine,
# the symlink step is optional; /opt/LastOS is always the true install path.
migrate_lastos() {
    local OLD="/LastOS"
    local NEW="/opt/LastOS"

    if [ -L "$OLD" ]; then
        echo "Migration: $OLD is already a symlink — skipping move."
        return 0
    fi

    if [ -d "$OLD" ]; then
        echo "Migration: Moving existing $OLD → $NEW..."
        mkdir -p "$NEW"
        # Prefer rsync; fall back to manual copy loop.
        if command -v rsync >/dev/null 2>&1; then
            rsync -a "$OLD/" "$NEW/"
            MIGRATE_OK=$?
        else
            MIGRATE_OK=0
            for _item in "$OLD"/.[!.]* "$OLD"/*; do
                [ -e "$_item" ] || continue
                cp -a "$_item" "$NEW/" 2>/dev/null || MIGRATE_OK=1
            done
        fi

        if [ "$MIGRATE_OK" -eq 0 ]; then
            echo "Migration: Move complete. Removing old $OLD..."
            rm -rf "$OLD"
            echo "Migration: Creating symlink $OLD → $NEW"
            if ln -sf "$NEW" "$OLD" 2>/dev/null; then
                echo "Migration: Symlink created successfully."
            else
                echo "Migration: Could not create symlink (immutable filesystem?) — continuing without it."
            fi
        else
            echo "Migration WARNING: Transfer had errors; leaving $OLD in place."
        fi
        return 0
    fi

    # /LastOS doesn't exist at all — just try to make the symlink.
    echo "Migration: $OLD does not exist. Creating symlink $OLD → $NEW..."
    if ln -sf "$NEW" "$OLD" 2>/dev/null; then
        echo "Migration: Symlink created."
    else
        echo "Migration: Could not create symlink (immutable filesystem?) — continuing without it."
    fi
}
migrate_lastos

# ── /opt/LastOS/Tools directory ──────────────────────────────────────────────
mkdir -p /opt/LastOS/Tools
chown root:lastos-users /opt/LastOS /opt/LastOS/Tools 2>/dev/null || true
chmod 775 /opt/LastOS /opt/LastOS/Tools

# ── Uninstall.sh ─────────────────────────────────────────────────────────────
cat << 'UNINSTALL_EOF' > /opt/LastOS/Tools/Uninstall.sh
#!/usr/bin/env bash

DESKTOP="$1"
SILENT=false

for ARG in "$@"; do
    [ "$ARG" = "--silent" ] && SILENT=true
done

say() { [ "$SILENT" = false ] && echo "$@"; }

if [ "$SILENT" = false ]; then
    clear
    echo
    echo "======================================"
    echo "        LastOS Uninstaller"
    echo "======================================"
    echo
fi

if [ ! -f "$DESKTOP" ]; then
    say "Desktop file missing"
    [ "$SILENT" = false ] && sleep 3
    exit 1
fi

NAME=$(grep "^Name=" "$DESKTOP" | head -1 | cut -d= -f2)
DESKEXEC=$(grep "^Exec=" "$DESKTOP" | head -1 | cut -d= -f2-)
DESKPATH=$(grep "^Path=" "$DESKTOP" | head -1 | cut -d= -f2-)

IS_SSAPP=false
if echo "$DESKEXEC$DESKPATH" | grep -qi "\.wine\|ppApps\|ppGames"; then
    IS_SSAPP=true
fi

say "Application:"
say "$NAME"
say

TARGETS=()

if [ -n "$DESKPATH" ] && [ -d "$DESKPATH" ]; then
    TARGETS+=("$DESKPATH")
fi

if [ ${#TARGETS[@]} -eq 0 ]; then
    for L in "$HOME/LLApps/$NAME" "$HOME/LLGames/$NAME" \
             "$HOME/.wine/drive_c/ppApps/$NAME" "$HOME/.wine/drive_c/ppGames/$NAME"; do
        [ -d "$L" ] && TARGETS+=("$L")
    done
fi

if [ ${#TARGETS[@]} -eq 0 ]; then
    say "Searching..."
    while IFS= read -r -d "" E; do TARGETS+=("$E"); done \
        < <(find "$HOME/LLApps" "$HOME/LLGames" \
                 "$HOME/.wine/drive_c/ppApps" "$HOME/.wine/drive_c/ppGames" \
                 -maxdepth 1 -type d -iname "*$NAME*" -print0 2>/dev/null)
fi

if [ ${#TARGETS[@]} -eq 0 ]; then
    say
    say "Install not found"
    say
    if [ "$SILENT" = false ] && [ "$IS_SSAPP" = true ]; then
        if command -v wine >/dev/null 2>&1; then
            echo "Opening Wine uninstaller..."
            wine uninstaller
        else
            echo "Wine is not installed."
        fi
    else
        say "Nothing to remove."
    fi
    [ "$SILENT" = false ] && sleep 3
    exit 0
fi

say
say "Removing..."
for T in "${TARGETS[@]}"; do
    say "$T"
    rm -rf "$T"
done

say
say "Removing menu entry..."
rm -f "$DESKTOP"

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null
fi

say
say "Uninstall Complete"
say

if [ "$SILENT" = false ]; then
    echo "Self closing in 3 seconds, press space to keep terminal open..."
    if read -r -s -n 1 -t 3 _KEY; then
        sleep 0.5
        while read -r -s -n 1 -t 0 _ 2>/dev/null; do :; done
        echo "Press ESC to close"
        while read -r -s -n 1 _KEY; do
            [ "$_KEY" = $'\e' ] && break
        done
    fi
fi
UNINSTALL_EOF

chmod 775 /opt/LastOS/Tools/Uninstall.sh
chown root:lastos-users /opt/LastOS/Tools/Uninstall.sh

# ── UninstallLauncher.sh ──────────────────────────────────────────────────────
cat << 'LAUNCHER_EOF' > /opt/LastOS/Tools/UninstallLauncher.sh
#!/usr/bin/env bash
DESKTOP="$1"
SILENT="$2"

if [ "$SILENT" = "--silent" ]; then
    bash /opt/LastOS/Tools/Uninstall.sh "$DESKTOP" --silent
    exit 0
fi

if   command -v konsole             >/dev/null 2>&1; then
    konsole -e bash /opt/LastOS/Tools/Uninstall.sh "$DESKTOP"
elif command -v gnome-terminal      >/dev/null 2>&1; then
    gnome-terminal --title="LastOS Uninstall" -- bash /opt/LastOS/Tools/Uninstall.sh "$DESKTOP"
elif command -v xfce4-terminal      >/dev/null 2>&1; then
    xfce4-terminal -e "bash /opt/LastOS/Tools/Uninstall.sh '$DESKTOP'"
elif command -v mate-terminal       >/dev/null 2>&1; then
    mate-terminal -e "bash /opt/LastOS/Tools/Uninstall.sh '$DESKTOP'"
elif command -v lxterminal          >/dev/null 2>&1; then
    lxterminal -e "bash /opt/LastOS/Tools/Uninstall.sh '$DESKTOP'"
elif command -v x-terminal-emulator >/dev/null 2>&1; then
    x-terminal-emulator -e "bash /opt/LastOS/Tools/Uninstall.sh '$DESKTOP'"
elif command -v xterm               >/dev/null 2>&1; then
    xterm -e "bash /opt/LastOS/Tools/Uninstall.sh '$DESKTOP'"
else
    exit 1
fi
LAUNCHER_EOF

chmod 775 /opt/LastOS/Tools/UninstallLauncher.sh
chown root:lastos-users /opt/LastOS/Tools/UninstallLauncher.sh

echo "Elevated setup complete."
SUDO_BODY

chmod +x "$SUDO_SCRIPT"
sudo bash "$SUDO_SCRIPT"
SUDO_EXIT=$?
rm -f "$SUDO_SCRIPT"

if [[ $SUDO_EXIT -ne 0 ]]; then
    echo "Warning: Setup script returned exit code $SUDO_EXIT — some steps may not have completed."
fi

# ---------------------------------------------------------------------------
# 5. gnome-terminal Wayland theme fix  (no sudo needed)
# ---------------------------------------------------------------------------
if [[ "$SYS_TERMINAL" == "gnome-terminal" ]] && [[ "$SESSION_TYPE" == "wayland" ]]; then
    header "Applying gnome-terminal Wayland theme fix..."
    if command -v gsettings &>/dev/null; then
        PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default 2>/dev/null || true)
        if [[ -n "$PROFILE" ]]; then
            PROFILE="${PROFILE:1:-1}"
            PKEY="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${PROFILE}/"
            gsettings set "$PKEY" use-theme-colors  'false'            2>/dev/null || true
            gsettings set "$PKEY" foreground-color  'rgb(208,207,204)' 2>/dev/null || true
            gsettings set "$PKEY" background-color  'rgb(23,20,33)'    2>/dev/null || true
            echo "Wayland theme fix applied to profile: $PROFILE"
        else
            echo "Note: Could not read gnome-terminal default profile — skipping."
        fi
    fi
fi

# ---------------------------------------------------------------------------
# 6. Desktop shortcuts  (no sudo needed)
# ---------------------------------------------------------------------------
header "Installing desktop shortcuts..."
mkdir -p "$HOME/.local/share/applications"
cp -f "$TOOLS"/*.desktop "$HOME/.local/share/applications/" 2>/dev/null || true
echo "Done."

# ---------------------------------------------------------------------------
# 7. Launch llstore -setup via sg so the new group is active immediately.
#    sg is part of shadow/shadow-utils which ships on every supported distro.
# ---------------------------------------------------------------------------
header "Launching llstore -setup..."

if [[ "$SESSION_TYPE" == "wayland" ]]; then
    LAUNCH_CMD="env GDK_BACKEND=x11 \"$SCRIPT_DIR/llstore\" -setup"
else
    LAUNCH_CMD="\"$SCRIPT_DIR/llstore\" -setup"
fi

# Use sg to activate the lastos-users GID for this process so llstore -setup
# can write to /opt/LastOS/Tools without needing sudo again.
# sg fails with a confusing "user does not exist" message when either:
#   (a) the group itself doesn't exist, or
#   (b) the current user is not yet a member of it
# Guard against both cases and fall back to a plain launch so at minimum
# the install still completes (LLStore will request sudo again if needed).
if command -v sg &>/dev/null && \
   getent group lastos-users &>/dev/null && \
   id -nG "$REAL_USER" 2>/dev/null | grep -qw "lastos-users"; then
    echo "Activating lastos-users group via sg..."
    sg lastos-users -c "cd \"$SCRIPT_DIR\" && $LAUNCH_CMD"
else
    echo "Note: launching directly (sg unavailable or lastos-users not yet active in this session)."
    echo "      LLStore will request elevated permissions if needed."
    cd "$SCRIPT_DIR" && eval "$LAUNCH_CMD"
fi

echo
echo "==> setup.sh complete."
