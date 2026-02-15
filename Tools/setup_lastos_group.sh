#!/bin/bash
# =============================================================================
# setup_lastos_group.sh  -  LastOS security-hardened folder permissions
# =============================================================================
# Replaces chmod 777 on /LastOS (and sub-dirs) with a proper group-based model:
#   - Creates the 'lastos-users' group if it doesn't exist
#   - Adds the calling (non-root) user to that group
#   - Sets ownership  :  root:lastos-users
#   - Sets SGID       :  2775  (new files inherit the group automatically)
#   - Applies ACLs    :  default ACLs so every new file/dir gets group rwx
#
# Usage:
#   sudo bash setup_lastos_group.sh [target_dir]
#   Default target_dir is /LastOS
#
# Compatible with: Debian/Ubuntu, Fedora/RHEL/CentOS, Arch, openSUSE,
#                  Solus, Alpine, Void, and any distro with useradd/groupadd
#                  or adduser/addgroup (BusyBox/Alpine).
# =============================================================================

GROUP="lastos-users"
TARGET_DIR="${1:-/LastOS}"

# --------------------------------------------------------------------------
# Detect the real user (works whether called via sudo, pkexec, or kdesu)
# --------------------------------------------------------------------------
REAL_USER="${SUDO_USER:-${PKEXEC_UID:+$(id -nu "$PKEXEC_UID")}}"
if [ -z "$REAL_USER" ]; then
    # Last resort: walk up PPID tree looking for a non-root login
    REAL_USER=$(who am i 2>/dev/null | awk '{print $1}')
fi
if [ -z "$REAL_USER" ] || [ "$REAL_USER" = "root" ]; then
    REAL_USER="$USER"
fi

# --------------------------------------------------------------------------
# Helper: print a notice
# --------------------------------------------------------------------------
info() { echo "[LastOS] $*"; }

# --------------------------------------------------------------------------
# Fallback: if group setup fails at any point, use chmod 777
# --------------------------------------------------------------------------
fallback_777() {
    info "WARNING: Falling back to chmod -R 777 on $TARGET_DIR (group setup unavailable)"
    chmod -R 777 "$TARGET_DIR"
    exit 0
}

# --------------------------------------------------------------------------
# 1. Create group if it doesn't exist
# --------------------------------------------------------------------------
if ! getent group "$GROUP" > /dev/null 2>&1; then
    info "Creating group: $GROUP"
    if command -v groupadd >/dev/null 2>&1; then
        groupadd --system "$GROUP" 2>/dev/null || groupadd "$GROUP" 2>/dev/null
    elif command -v addgroup >/dev/null 2>&1; then
        addgroup --system "$GROUP" 2>/dev/null || addgroup "$GROUP" 2>/dev/null
    fi
    # Check if group creation actually succeeded — if not, fall back
    if ! getent group "$GROUP" > /dev/null 2>&1; then
        info "WARNING: Could not create group '$GROUP'."
        fallback_777
    fi
else
    info "Group '$GROUP' already exists."
fi

# --------------------------------------------------------------------------
# 2. Add the real (non-root) user to the group
# --------------------------------------------------------------------------
if [ -n "$REAL_USER" ] && [ "$REAL_USER" != "root" ]; then
    if id -nG "$REAL_USER" 2>/dev/null | grep -qw "$GROUP"; then
        info "User '$REAL_USER' is already in group '$GROUP'."
    else
        info "Adding user '$REAL_USER' to group '$GROUP'..."
        if command -v usermod >/dev/null 2>&1; then
            usermod -aG "$GROUP" "$REAL_USER"
        elif command -v adduser >/dev/null 2>&1; then
            adduser "$REAL_USER" "$GROUP"
        elif command -v gpasswd >/dev/null 2>&1; then
            gpasswd -a "$REAL_USER" "$GROUP"
        else
            info "WARNING: Cannot add user to group - no usermod/adduser/gpasswd found."
        fi
    fi
fi

# --------------------------------------------------------------------------
# 3. Create the target directory if needed
# --------------------------------------------------------------------------
if [ ! -d "$TARGET_DIR" ]; then
    info "Creating directory: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

# --------------------------------------------------------------------------
# 4. Set ownership  root:lastos-users  recursively
# --------------------------------------------------------------------------
info "Setting ownership: root:$GROUP on $TARGET_DIR"
chown -R root:"$GROUP" "$TARGET_DIR"

# --------------------------------------------------------------------------
# 5. Set SGID 2775 on all directories, and 664/775 on files
#    2775 = setgid + rwxrwxr-x
#    Capital X = execute only if already executable or is a directory
# --------------------------------------------------------------------------
info "Setting SGID 2775 on directories under $TARGET_DIR"
# Files get u=rwX,g=rwX,o=rX  (executable bit kept if file was already exec)
chmod -R u=rwX,g=rwX,o=rX "$TARGET_DIR"
# Apply setgid to every directory so new files inherit lastos-users group
find "$TARGET_DIR" -type d -exec chmod g+s {} \;

# --------------------------------------------------------------------------
# 6. Apply POSIX ACLs if setfacl is available
#    Default ACLs ensure every new file/subdir inherits group rwx
# --------------------------------------------------------------------------
if command -v setfacl >/dev/null 2>&1; then
    info "Applying POSIX ACLs (default ACL inheritance) on $TARGET_DIR"
    # Set current ACLs
    setfacl -m g:"$GROUP":rwx "$TARGET_DIR"
    # Set default ACLs (inherited by new files/dirs)
    setfacl -d -m u::rwx  "$TARGET_DIR"
    setfacl -d -m g:"$GROUP":rwx "$TARGET_DIR"
    setfacl -d -m o::rx   "$TARGET_DIR"
    # Propagate default ACLs to all existing subdirectories as well
    find "$TARGET_DIR" -type d | while IFS= read -r dir; do
        setfacl -m  g:"$GROUP":rwx "$dir" 2>/dev/null
        setfacl -d -m u::rwx       "$dir" 2>/dev/null
        setfacl -d -m g:"$GROUP":rwx "$dir" 2>/dev/null
        setfacl -d -m o::rx        "$dir" 2>/dev/null
    done
else
    info "Note: 'setfacl' not found - skipping ACL setup (SGID is still active)."
    info "      Install 'acl' package for full ACL support: apt/dnf/pacman install acl"
fi

# --------------------------------------------------------------------------
# 7. Summary
# --------------------------------------------------------------------------
info "Done. $TARGET_DIR is now owned by root:$GROUP with SGID 2775."
info ""
if [ -n "$REAL_USER" ] && [ "$REAL_USER" != "root" ]; then
    info "IMPORTANT: '$REAL_USER' has been added to '$GROUP'."
    info "           A logout/login (or 'newgrp $GROUP') is required"
    info "           for the new group membership to take effect in this session."
fi
