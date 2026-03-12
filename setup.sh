#!/bin/bash
# =============================================================================
# LLStore setup.sh  -  Bootstrap Installer
# -----------------------------------------------------------------------------
# Runs a SINGLE sudo call that covers everything requiring root:
#   - lastos-users group creation and user membership
#   - migration of /LastOS → /opt/LastOS with backward-compat symlink
#   - /opt/LastOS/Tools creation, ownership, permissions
# Then launches llstore -setup via 'sg lastos-users' so the new group is
# active in the session immediately — no re-login, no second run needed.
# =============================================================================

# Clear the variable that often auto-resets the title
unset PROMPT_COMMAND
printf '\033]0;LLStore Installer\007'

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

REAL_USER="${SUDO_USER:-$USER}"
SESSION_TYPE="${XDG_SESSION_TYPE:-x11}"
SESSION_TYPE="${SESSION_TYPE,,}"

SYS_TERMINAL=""
for t in ptyxis gnome-terminal konsole xfce4-terminal mate-terminal lxterminal \
         qterminal tilix terminator alacritty kitty foot x-terminal-emulator xterm; do
    if command -v "$t" &>/dev/null; then SYS_TERMINAL="$t"; break; fi
done

# ---------------------------------------------------------------------------
# 1. Build and run ONE sudo script covering everything elevated.
#
#    IMPORTANT: The variable header uses an unquoted heredoc so that
#    $REAL_USER and $TOOLS are expanded NOW from the setup.sh environment.
#    The body uses a QUOTED heredoc so bash variables inside are literals.
# ---------------------------------------------------------------------------
echo "Setting up lastos-users group..."

SUDO_SCRIPT="$(mktemp /tmp/llstore_setup_XXXXXX.sh)"

# ── Part 1: variable header (unquoted — expands NOW) ────────────────────────
cat > "$SUDO_SCRIPT" << SUDO_HEADER
#!/bin/bash
set -e
REAL_USER="${REAL_USER}"
TOOLS="${TOOLS}"
SUDO_HEADER

# ── Part 2: the rest of the script (quoted — no premature expansion) ─────────
cat >> "$SUDO_SCRIPT" << 'SUDO_BODY'

# ── lastos-users group + user membership + folder structure ──────────────────
if [[ -f "$TOOLS/setup_lastos_group.sh" ]]; then
    bash "$TOOLS/setup_lastos_group.sh" /opt/LastOS
else
    groupadd --system lastos-users 2>/dev/null || true
    usermod -aG lastos-users "$REAL_USER" 2>/dev/null || true
fi

mkdir -p /opt/LastOS/Tools
chown root:lastos-users /opt/LastOS /opt/LastOS/Tools 2>/dev/null || true
chmod 775 /opt/LastOS /opt/LastOS/Tools

# ── Migrate /LastOS → /opt/LastOS (if needed) and create symlink ─────────────
# On immutable distros (Bazzite etc.) / may not be writable - that's fine,
# the symlink step is optional; /opt/LastOS is always the true install path.
migrate_lastos() {
    local OLD="/LastOS"
    local NEW="/opt/LastOS"

    if [ -L "$OLD" ]; then
        return 0
    fi

    if [ -d "$OLD" ]; then
        mkdir -p "$NEW"
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
            rm -rf "$OLD"
            ln -sf "$NEW" "$OLD" 2>/dev/null || true
        fi
        return 0
    fi

    # /LastOS doesn't exist at all — just try to make the symlink.
    ln -sf "$NEW" "$OLD" 2>/dev/null || true
}
migrate_lastos

SUDO_BODY

chmod +x "$SUDO_SCRIPT"
sudo bash "$SUDO_SCRIPT"
SUDO_EXIT=$?
rm -f "$SUDO_SCRIPT"

if [[ $SUDO_EXIT -ne 0 ]]; then
    echo "Warning: Setup returned exit code $SUDO_EXIT — some steps may not have completed."
fi

# ---------------------------------------------------------------------------
# 2. gnome-terminal Wayland theme fix  (no sudo needed)
# ---------------------------------------------------------------------------
if [[ "$SYS_TERMINAL" == "gnome-terminal" ]] && [[ "$SESSION_TYPE" == "wayland" ]]; then
    if command -v gsettings &>/dev/null; then
        PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default 2>/dev/null || true)
        if [[ -n "$PROFILE" ]]; then
            PROFILE="${PROFILE:1:-1}"
            PKEY="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${PROFILE}/"
            gsettings set "$PKEY" use-theme-colors  'false'            2>/dev/null || true
            gsettings set "$PKEY" foreground-color  'rgb(208,207,204)' 2>/dev/null || true
            gsettings set "$PKEY" background-color  'rgb(23,20,33)'    2>/dev/null || true
        fi
    fi
fi

# ---------------------------------------------------------------------------
# 3. Desktop shortcuts  (no sudo needed)
# ---------------------------------------------------------------------------
mkdir -p "$HOME/.local/share/applications"
cp -f "$TOOLS"/*.desktop "$HOME/.local/share/applications/" 2>/dev/null || true

# ---------------------------------------------------------------------------
# 4. Launch llstore -setup via sg so the new group is active immediately.
# ---------------------------------------------------------------------------
echo "Running LLStore Setup..."

if [[ "$SESSION_TYPE" == "wayland" ]]; then
    LAUNCH_CMD="env GDK_BACKEND=x11 \"$SCRIPT_DIR/llstore\" -setup"
else
    LAUNCH_CMD="\"$SCRIPT_DIR/llstore\" -setup"
fi

if command -v sg &>/dev/null && \
   getent group lastos-users &>/dev/null && \
   id -nG "$REAL_USER" 2>/dev/null | grep -qw "lastos-users"; then
    sg lastos-users -c "cd \"$SCRIPT_DIR\" && $LAUNCH_CMD"
else
    cd "$SCRIPT_DIR" && eval "$LAUNCH_CMD"
fi
