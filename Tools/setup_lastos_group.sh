#!/bin/bash
# =============================================================================
# setup_lastos_group.sh  -  LastOS security-hardened folder permissions
# =============================================================================

if [[ $EUID -ne 0 ]]; then
    echo "This script requires sudo ./setup_lastos_group.sh"
    exit 1
fi

GROUP="lastos-users"
TARGET_DIR="${1:-/opt/LastOS}"

warn() { echo "WARNING: $*" >&2; }

# --------------------------------------------------------------------------
# Detect the real user (even under sudo/pkexec)
# --------------------------------------------------------------------------
REAL_USER=""

[ -n "${SUDO_USER:-}" ]  && [ "$SUDO_USER"  != "root" ] && REAL_USER="$SUDO_USER"

if [ -z "$REAL_USER" ] && [ -n "${PKEXEC_UID:-}" ]; then
    _PKU=$(id -nu "$PKEXEC_UID" 2>/dev/null)
    [ -n "$_PKU" ] && [ "$_PKU" != "root" ] && REAL_USER="$_PKU"
fi

if [ -z "$REAL_USER" ]; then
    _LN=$(logname 2>/dev/null)
    [ -n "$_LN" ] && [ "$_LN" != "root" ] && REAL_USER="$_LN"
fi

if [ -z "$REAL_USER" ]; then
    _WI=$(who am i 2>/dev/null | awk '{print $1}')
    [ -n "$_WI" ] && [ "$_WI" != "root" ] && REAL_USER="$_WI"
fi

if [ -z "$REAL_USER" ] && [ -n "${USER:-}" ] && [ "$USER" != "root" ]; then
    REAL_USER="$USER"
fi

# --------------------------------------------------------------------------
# 1. Create the lastos-users group (if it doesn't exist)
# --------------------------------------------------------------------------
if ! getent group "$GROUP" > /dev/null 2>&1; then
    echo "Creating group: $GROUP"
    if command -v groupadd > /dev/null 2>&1; then
        groupadd --system "$GROUP"
    elif command -v addgroup > /dev/null 2>&1; then
        addgroup --system "$GROUP"
    else
        warn "Neither groupadd nor addgroup found — cannot create group"
    fi
    getent group "$GROUP" > /dev/null 2>&1 || warn "Group '$GROUP' could not be created. Folder permissions may be limited."
else
    echo "Group already exists..."
fi

# --------------------------------------------------------------------------
# 2. Add the real user to the group (if not already a member)
# --------------------------------------------------------------------------
if [ -n "$REAL_USER" ] && getent group "$GROUP" > /dev/null 2>&1; then
    if ! getent group "$GROUP" | awk -F: '{print $4}' | tr ',' '\n' | grep -qx "$REAL_USER"; then
        echo "Adding $REAL_USER to $GROUP..."
        if command -v usermod > /dev/null 2>&1; then
            usermod -aG "$GROUP" "$REAL_USER"
        else
            adduser "$REAL_USER" "$GROUP"
        fi
        getent group "$GROUP" | awk -F: '{print $4}' | tr ',' '\n' | grep -qx "$REAL_USER" \
            || warn "Could not confirm '$REAL_USER' was added to '$GROUP'"
    else
        echo "You're already part of lastos-users..."
    fi
elif [ -z "$REAL_USER" ]; then
    warn "Could not determine real user — skipping group membership step"
fi

# --------------------------------------------------------------------------
# 3. Make lastos-users the default for future new users (Debian/Ubuntu)
# --------------------------------------------------------------------------
if [ -f /etc/adduser.conf ]; then
    sed -i "s|^#\?EXTRA_GROUPS=.*|EXTRA_GROUPS=\"$GROUP\"|"  /etc/adduser.conf
    sed -i "s|^#\?ADD_EXTRA_GROUPS=.*|ADD_EXTRA_GROUPS=1|"   /etc/adduser.conf
fi

# --------------------------------------------------------------------------
# 4. Directory setup and permissions
# --------------------------------------------------------------------------
echo "Setting up $TARGET_DIR..."
mkdir -p "$TARGET_DIR"
chown -R root:"$GROUP" "$TARGET_DIR"
find "$TARGET_DIR" -type d -exec chmod 775 {} +
find "$TARGET_DIR" -type f \( -name "*.sh" -o -name "*.py" -o -name "*.run" \
     -o -name "*.AppImage" -o -name "llstore" -o -name "*.so" \
     -o -perm /111 \) -exec chmod 775 {} +
find "$TARGET_DIR" -type f ! -name "*.sh" ! -name "*.py" ! -name "*.run" \
     ! -name "*.AppImage" ! -name "llstore" ! -name "*.so" \
     ! -perm /111 -exec chmod 664 {} +
