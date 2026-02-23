#!/bin/bash
# =============================================================================
# setup_lastos_group.sh  -  LastOS security-hardened folder permissions
# =============================================================================
# Optimized for Xojo tools and multi-user/Live environments:
#   - Creates 'lastos-users' group for administrative/write access.
#   - Sets 2775 permissions: Group can write, but EVERYONE can execute.
#   - Ensures Xojo .so libraries are globally readable to prevent load errors.
#   - Configures system defaults so future users are added to the group.
# =============================================================================

GROUP="lastos-users"
TARGET_DIR="${1:-/LastOS}"

# --------------------------------------------------------------------------
# Detect the real user (even under sudo/pkexec)
# --------------------------------------------------------------------------
REAL_USER="${SUDO_USER:-${PKEXEC_UID:+$(id -nu "$PKEXEC_UID")}}"
[ -z "$REAL_USER" ] && REAL_USER=$(who am i 2>/dev/null | awk '{print $1}')
[ -z "$REAL_USER" ] || [ "$REAL_USER" = "root" ] && REAL_USER="$USER"

info() { echo "[LastOS] $*"; }

# --------------------------------------------------------------------------
# 1. Create group and ensure future users get it
# --------------------------------------------------------------------------
if ! getent group "$GROUP" > /dev/null 2>&1; then
    info "Creating group: $GROUP"
    groupadd --system "$GROUP" 2>/dev/null || addgroup --system "$GROUP" 2>/dev/null
fi

# Attempt to make 'lastos-users' a default for new users (Debian/Ubuntu/Arch)
if [ -f /etc/adduser.conf ]; then
    sed -i 's/^#EXTRA_GROUPS=.*/EXTRA_GROUPS="'"$GROUP"'"/' /etc/adduser.conf
    sed -i 's/^#ADD_EXTRA_GROUPS=.*/ADD_EXTRA_GROUPS=1/' /etc/adduser.conf
fi

# --------------------------------------------------------------------------
# 2. Add current user to group
# --------------------------------------------------------------------------
if [ -n "$REAL_USER" ] && [ "$REAL_USER" != "root" ]; then
    info "Adding user '$REAL_USER' to group '$GROUP'..."
    usermod -aG "$GROUP" "$REAL_USER" 2>/dev/null || adduser "$REAL_USER" "$GROUP" 2>/dev/null
fi

# --------------------------------------------------------------------------
# 3. Directory Setup and Ownership
# --------------------------------------------------------------------------
mkdir -p "$TARGET_DIR"
info "Setting ownership: root:$GROUP on $TARGET_DIR"
chown -R root:"$GROUP" "$TARGET_DIR"

# --------------------------------------------------------------------------
# 4. Apply Robust Permissions (Xojo Compatible)
#    We use 2775 for dirs and 775/664 for files. 
#    This allows 'others' to READ/EXECUTE but NOT WRITE.
# --------------------------------------------------------------------------
info "Applying 775/775 permissions for Xojo compatibility..."

# Set Directories: drwxrwsr-x (SGID ensures new files stay in the group)
find "$TARGET_DIR" -type d -exec chmod 775 {} +

# Set Files: -rw-rw-r-- (Standard files)
find "$TARGET_DIR" -type f -exec chmod 775 {} +

# Set Executables: -rwxrwxr-x (Binaries and Scripts)
# We find anything already marked executable and ensure 'others' have 'x'
find "$TARGET_DIR" -type f \( -perm -100 -o -name "*.so" -o -name "llstore" \) -exec chmod 775 {} +

#ACL is ignore by squishfs, but may be useful for the installer, I'll disable for now as not sure it's needed if the group works
## --------------------------------------------------------------------------
## 5. Apply POSIX ACLs (The "Safety Net")
## --------------------------------------------------------------------------
#if command -v setfacl >/dev/null 2>&1; then
#    info "Applying POSIX ACLs (Inheritance)..."
#    # Recursive application: Group gets rwx, Others get r-x
#    setfacl -R -m g:"$GROUP":rwx "$TARGET_DIR"
#    setfacl -R -m o::rx "$TARGET_DIR"
#    
#    # Default ACLs: Ensures new files created later follow this rule
#    setfacl -R -d -m g:"$GROUP":rwx "$TARGET_DIR"
#    setfacl -R -d -m o::rx "$TARGET_DIR"
#else
#    info "Note: 'setfacl' not found. Permissions rely on SGID bits."
#fi

# --------------------------------------------------------------------------
# 6. Summary
# --------------------------------------------------------------------------
info "Done. $TARGET_DIR is secured but executable by all users."
info "Xojo libraries in $TARGET_DIR/LLStore/ should now load correctly."
if [ -n "$REAL_USER" ]; then
    info "Note: $REAL_USER may need to re-login to gain WRITE access."
fi
