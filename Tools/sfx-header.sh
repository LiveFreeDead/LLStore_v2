#!/bin/bash
# =============================================================================
# LLStore SFX Header
# Self-extracting installer. The archive is appended after __ARCHIVE_FOLLOWS__
# Usage: ./MyGame.run
# =============================================================================

# Do NOT use set -e here – we capture STATUS manually after install.sh
# and want the cleanup/summary code to always run.

# Ensure USER and HOME are always set
USER="${USER:-$(id -un 2>/dev/null || echo "user")}"
HOME="${HOME:-/root}"
export USER HOME

# ---------------------------------------------------------------------------
# Determine where we are running from
# ---------------------------------------------------------------------------
SELF="$(readlink -f "$0" 2>/dev/null || echo "$0")"

# ---------------------------------------------------------------------------
# Detect a terminal
# ---------------------------------------------------------------------------
in_terminal() { [ -t 0 ] && [ -t 1 ]; }

# ---------------------------------------------------------------------------
# If not in a terminal, try to re-launch inside one
# ---------------------------------------------------------------------------
relaunch_in_terminal() {
    local terms=(gnome-terminal konsole kde-ptyxis xfce4-terminal lxterminal \
                 x-terminal-emulator xterm)
    for t in "${terms[@]}"; do
        if command -v "$t" &>/dev/null; then
            case "$t" in
                gnome-terminal)     exec "$t" -- bash "$SELF" "$@" ;;
                konsole|kde-ptyxis) exec "$t" -e bash "$SELF" "$@" ;;
                *)                  exec "$t" -e bash "$SELF" "$@" ;;
            esac
        fi
    done
    # Last resort – run headless
    bash "$SELF" "$@"
    exit $?
}

if ! in_terminal; then
    relaunch_in_terminal "$@"
fi

echo ""
echo "=================================================="
echo "  LLStore SFX Installer"
echo "=================================================="
echo ""

# ---------------------------------------------------------------------------
# Create a temp directory for extraction under home (not /tmp)
# The entire CLI-Installer folder is removed on exit.
# ---------------------------------------------------------------------------
EXTRACT_TMP="$HOME/.lltemp/CLI-Installer/sfx-$$"
mkdir -p "$EXTRACT_TMP"

cleanup_sfx() {
    rm -rf "$HOME/.lltemp/CLI-Installer"
    rmdir "$HOME/.lltemp" 2>/dev/null || true
}
trap 'cleanup_sfx' EXIT

echo "Extracting installer package..."

# ---------------------------------------------------------------------------
# Find the line number immediately after __ARCHIVE_FOLLOWS__
# ---------------------------------------------------------------------------
SKIP=$(awk '/^__ARCHIVE_FOLLOWS__$/ { print NR + 1; exit 0; }' "$SELF")

if [ -z "$SKIP" ]; then
    echo "ERROR: Archive marker not found in this file. SFX may be corrupt."
    exit 1
fi

# ---------------------------------------------------------------------------
# Extract the embedded tar.gz archive
# ---------------------------------------------------------------------------
tail -n +"$SKIP" "$SELF" | tar xzf - -C "$EXTRACT_TMP"
EXTRACT_STATUS=$?
if [ "$EXTRACT_STATUS" -ne 0 ]; then
    echo "ERROR: Failed to extract archive (status $EXTRACT_STATUS)."
    exit 1
fi

echo "Extraction complete."
echo ""

# ---------------------------------------------------------------------------
# Locate the installer content – install.sh is inside Tools/
# ---------------------------------------------------------------------------
INSTALL_DIR=""
# Try root of extracted dir first (myfiles/Tools/install.sh)
if [ -f "$EXTRACT_TMP/Tools/install.sh" ]; then
    INSTALL_DIR="$EXTRACT_TMP"
elif [ -f "$EXTRACT_TMP/myfiles/Tools/install.sh" ]; then
    INSTALL_DIR="$EXTRACT_TMP/myfiles"
else
    # Try first subdirectory
    for d in "$EXTRACT_TMP"/*/; do
        if [ -f "${d}Tools/install.sh" ]; then
            INSTALL_DIR="${d%/}"
            break
        fi
    done
fi

if [ -z "$INSTALL_DIR" ] || [ ! -f "$INSTALL_DIR/Tools/install.sh" ]; then
    echo "ERROR: Tools/install.sh not found in extracted archive."
    exit 1
fi

# ---------------------------------------------------------------------------
# Make all bundled tools executable
# ---------------------------------------------------------------------------
find "$INSTALL_DIR/Tools" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
[ -f "$INSTALL_DIR/Tools/7zzs" ]   && chmod +x "$INSTALL_DIR/Tools/7zzs"   || true
[ -f "$INSTALL_DIR/Tools/7z.exe" ] && chmod +x "$INSTALL_DIR/Tools/7z.exe" || true

# ---------------------------------------------------------------------------
# Run the installer (install.sh lives inside Tools/)
# ---------------------------------------------------------------------------
echo "Starting installation..."
echo ""

cd "$INSTALL_DIR"
STATUS=0
bash ./Tools/install.sh || STATUS=$?

echo ""
if [ "$STATUS" -eq 0 ]; then
    echo "=================================================="
    echo "  Installation completed successfully."
    echo "=================================================="
else
    echo "=================================================="
    echo "  Installation finished with status: $STATUS"
    echo "  Check the output above for details."
    echo "=================================================="
    echo ""
    # Only pause on failure so batch runs aren't interrupted
    if in_terminal; then
        read -rp "Press Enter to close..." || true
    fi
fi

exit $STATUS

# ===========================================================================
# The archive is appended below this line – do NOT edit anything below here.
# ===========================================================================
__ARCHIVE_FOLLOWS__
