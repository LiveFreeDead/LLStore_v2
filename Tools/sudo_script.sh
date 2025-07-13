#!/bin/bash

# Cross-distribution sudo privilege escalation script
# This script attempts to run a command with elevated privileges
# using various methods available on different Linux distributions

# Function to display usage
usage() {
    echo "Usage: $0 <command> [arguments...]"
    echo "Example: $0 apt update"
    echo "Example: $0 /path/to/script.sh"
    exit 1
}

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    usage
fi

# Store the command and arguments
COMMAND="$@"

# Store original user information
ORIGINAL_USER="${SUDO_USER:-$USER}"
ORIGINAL_HOME="${HOME}"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to run command with elevated privileges
run_elevated() {
    local method="$1"
    local cmd="$2"
    
    echo "Attempting to run with elevated privileges using: $method"
    
    case "$method" in
        "pkexec")
            # pkexec preserves environment by default, but we can ensure HOME is set
            pkexec env HOME="$ORIGINAL_HOME" USER="$ORIGINAL_USER" bash -c "$cmd"
            ;;
        "sudo")
            # Use -E to preserve environment and explicitly set HOME
            sudo -E bash -c "export HOME='$ORIGINAL_HOME'; $cmd"
            ;;
        "doas")
            # doas doesn't have -E, but we can set environment variables
            doas env HOME="$ORIGINAL_HOME" USER="$ORIGINAL_USER" bash -c "$cmd"
            ;;
        "kdesu")
            # kdesu preserves user environment by default
            kdesu -c "export HOME='$ORIGINAL_HOME'; $cmd"
            ;;
        "gksu")
            # gksu preserves user environment
            gksu "export HOME='$ORIGINAL_HOME'; $cmd"
            ;;
        "kdesudo")
            # kdesudo similar to sudo
            kdesudo "export HOME='$ORIGINAL_HOME'; $cmd"
            ;;
        *)
            echo "Unknown method: $method"
            return 1
            ;;
    esac
}

# Array of privilege escalation methods to try, in order of preference
METHODS=(
    "pkexec"    # PolicyKit - works on most modern distributions
    "sudo"      # Traditional sudo
    "doas"      # OpenBSD's doas, available on some Linux distros
    "kdesu"     # KDE's graphical sudo
    "gksu"      # GNOME's graphical sudo (deprecated but still found)
    "kdesudo"   # Another KDE variant
)

# Check if we're already running as root
if [ "$EUID" -eq 0 ]; then
    echo "Already running as root, executing command directly..."
    bash -c "$COMMAND"
    exit $?
fi

# Try each method until one succeeds
SUCCESS=false
for method in "${METHODS[@]}"; do
    if command_exists "$method"; then
        echo "Found $method, attempting to use it..."
        
        # Special handling for pkexec which may need full path
        if [ "$method" = "pkexec" ]; then
            # For pkexec, we need to be more careful about the command structure
            if run_elevated "$method" "$COMMAND"; then
                SUCCESS=true
                break
            fi
        else
            if run_elevated "$method" "$COMMAND"; then
                SUCCESS=true
                break
            fi
        fi
        
        # Check exit status
        if [ $? -eq 0 ]; then
            SUCCESS=true
            break
        else
            echo "$method failed or was cancelled"
        fi
    fi
done

# If no method worked, provide helpful information
if [ "$SUCCESS" = false ]; then
    echo ""
    echo "ERROR: Could not execute command with elevated privileges!"
    echo ""
    echo "None of the following privilege escalation methods were available or successful:"
    for method in "${METHODS[@]}"; do
        if command_exists "$method"; then
            echo "  ✓ $method (available but failed)"
        else
            echo "  ✗ $method (not available)"
        fi
    done
    echo ""
    echo "To fix this, install one of the following packages:"
    echo "  - On Ubuntu/Debian: sudo apt install policykit-1"
    echo "  - On RHEL/CentOS/Fedora: sudo dnf install polkit"
    echo "  - On Arch Linux: sudo pacman -S polkit"
    echo "  - On openSUSE: sudo zypper install polkit"
    echo ""
    echo "Or ensure your user is in the appropriate group:"
    echo "  - sudo usermod -a -G sudo \$USER  (Ubuntu/Debian)"
    echo "  - sudo usermod -a -G wheel \$USER (RHEL/CentOS/Fedora/Arch)"
    echo ""
    echo "Then log out and log back in for group changes to take effect."
    exit 1
fi

echo "Command executed successfully with elevated privileges."