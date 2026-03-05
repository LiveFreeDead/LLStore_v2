#!/bin/bash
# =============================================================================
# setup_lastos_group.sh  -  LastOS security-hardened folder permissions
# =============================================================================

GROUP="lastos-users"
TARGET_DIR="${1:-/LastOS}"

# --------------------------------------------------------------------------
# Detect the real user (even under sudo/pkexec)
# --------------------------------------------------------------------------
# Priority order: SUDO_USER > PKEXEC_UID > logname > who am i > USER
# We never want to operate on root itself as the target user.
REAL_USER=""

# sudo sets SUDO_USER
[ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != "root" ] && REAL_USER="$SUDO_USER"

# pkexec sets PKEXEC_UID (numeric) - resolve to name
if [ -z "$REAL_USER" ] && [ -n "${PKEXEC_UID:-}" ]; then
    _PKU=$(id -nu "$PKEXEC_UID" 2>/dev/null)
    [ -n "$_PKU" ] && [ "$_PKU" != "root" ] && REAL_USER="$_PKU"
fi

# logname reads the login name from utmp, works in most terminal contexts
if [ -z "$REAL_USER" ]; then
    _LN=$(logname 2>/dev/null)
    [ -n "$_LN" ] && [ "$_LN" != "root" ] && REAL_USER="$_LN"
fi

# who am i reads the controlling tty owner
if [ -z "$REAL_USER" ]; then
    _WI=$(who am i 2>/dev/null | awk '{print $1}')
    [ -n "$_WI" ] && [ "$_WI" != "root" ] && REAL_USER="$_WI"
fi

# Last resort: $USER if it was explicitly passed via "pkexec env USER=... bash"
# but only if it's not root
if [ -z "$REAL_USER" ] && [ -n "${USER:-}" ] && [ "$USER" != "root" ]; then
    REAL_USER="$USER"
fi

info() { echo "[LastOS] $*"; }
warn() { echo "[LastOS] WARNING: $*" >&2; }

info "Real user detected: ${REAL_USER:-<none>}"

# --------------------------------------------------------------------------
# 1. Create the lastos-users group
# --------------------------------------------------------------------------
if ! getent group "$GROUP" > /dev/null 2>&1; then
    info "Creating group: $GROUP"
    # Prefer groupadd (shadow-utils) - handles hyphenated names reliably
    if command -v groupadd > /dev/null 2>&1; then
        groupadd --system "$GROUP"
    elif command -v addgroup > /dev/null 2>&1; then
        addgroup --system "$GROUP"
    else
        warn "Neither groupadd nor addgroup found — cannot create group"
    fi

    # Verify group was actually created
    if ! getent group "$GROUP" > /dev/null 2>&1; then
        warn "Group '$GROUP' could not be created. Folder permissions may be limited."
        # Don't exit — still set up directory permissions as best we can
    else
        info "Group '$GROUP' created successfully"
    fi
else
    info "Group '$GROUP' already exists"
fi

# --------------------------------------------------------------------------
# 2. Add the real user to the group
# --------------------------------------------------------------------------
if [ -n "$REAL_USER" ] && getent group "$GROUP" > /dev/null 2>&1; then
    # Check via /etc/group directly (not session id — those need re-login)
    if getent group "$GROUP" | awk -F: '{print $4}' | tr ',' '\n' | grep -qx "$REAL_USER"; then
        info "User '$REAL_USER' is already a member of '$GROUP'"
    else
        info "Adding user '$REAL_USER' to group '$GROUP'..."
        if command -v usermod > /dev/null 2>&1; then
            usermod -aG "$GROUP" "$REAL_USER"
        else
            adduser "$REAL_USER" "$GROUP"
        fi

        # Verify the user was actually added
        if getent group "$GROUP" | awk -F: '{print $4}' | tr ',' '\n' | grep -qx "$REAL_USER"; then
            info "User '$REAL_USER' successfully added to '$GROUP'"
        else
            warn "Could not confirm '$REAL_USER' was added to '$GROUP'"
        fi
    fi
elif [ -z "$REAL_USER" ]; then
    warn "Could not determine real user — skipping group membership step"
fi

# --------------------------------------------------------------------------
# 3. Make lastos-users the default for future new users (Debian/Ubuntu)
# --------------------------------------------------------------------------
if [ -f /etc/adduser.conf ]; then
    # Replace whether the line is currently commented out or not,
    # and regardless of whatever value it previously had.
    sed -i "s|^#\?EXTRA_GROUPS=.*|EXTRA_GROUPS=\"$GROUP\"|" /etc/adduser.conf
    sed -i "s|^#\?ADD_EXTRA_GROUPS=.*|ADD_EXTRA_GROUPS=1|"  /etc/adduser.conf
fi

# --------------------------------------------------------------------------
# 4. Directory setup and permissions
# --------------------------------------------------------------------------
mkdir -p "$TARGET_DIR"
info "Setting ownership: root:$GROUP on $TARGET_DIR"
chown -R root:"$GROUP" "$TARGET_DIR"

info "Applying permissions: dirs=775 (rwxrwxr-x), scripts=775, data files=664 (rw-rw-r--)"
# Directories: root+group full access, others read+list+execute only (no write)
find "$TARGET_DIR" -type d -exec chmod 775 {} +
# Executable files (.sh, .py, .run, binary-flagged): same as dirs
find "$TARGET_DIR" -type f \( -name "*.sh" -o -name "*.py" -o -name "*.run" \
     -o -name "*.AppImage" -o -name "llstore" -o -name "*.so" \
     -o -perm /111 \) -exec chmod 775 {} +
# Everything else (ini, txt, desktop, png, etc.): group can rw, others read-only
find "$TARGET_DIR" -type f ! -name "*.sh" ! -name "*.py" ! -name "*.run" \
     ! -name "*.AppImage" ! -name "llstore" ! -name "*.so" \
     ! -perm /111 -exec chmod 664 {} +

# --------------------------------------------------------------------------
# 5. Summary
# --------------------------------------------------------------------------
info "Done. $TARGET_DIR is secured."
if [ -n "$REAL_USER" ]; then
    info "Note: '$REAL_USER' needs to re-login for the new group to be active in their session."
    info "      LLStore handles this automatically via 'sg' on first launch."
fi
