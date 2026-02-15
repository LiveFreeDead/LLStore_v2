#!/bin/bash

# Configuration: Move this out of /tmp to your user home
# This prevents other users from placing malicious scripts in the path
BASE_DIR="$HOME/.llstore_secure"
mkdir -p "$BASE_DIR"
chmod 700 "$BASE_DIR"

# Flag file paths (Updated to the secure dir)
SCRIPT_PATH="$BASE_DIR/LLScript_Sudo.sh"
DONE_FLAG="$BASE_DIR/LLSudoDone"
HANDSHAKE="$BASE_DIR/LLSudoHandShake"

echo "Sudo Listener Started (Secure Mode)"

# Cleanup leftovers from previous runs
rm -f "$SCRIPT_PATH"
rm -f "$DONE_FLAG"
rm -f "$BASE_DIR/LLSudo"

# Main Loop: Runs until the calling project creates LLSudoDone
while [ ! -f "$DONE_FLAG" ]
do
    # Check if a script (with your UUID-based name) has been placed here
    if [ -f "$SCRIPT_PATH" ]; then
        # Use chmod to make it executable (fixing the chown 775 error)
        chmod 775 "$SCRIPT_PATH"
        
        # Execute the script and then remove it immediately
        "$SCRIPT_PATH"
        rm -f "$SCRIPT_PATH"
    fi

    # Efficient sleep to save CPU cycles
    # Supports floating point for responsiveness
    sleep 0.1 2>/dev/null

    # Remove Handshake File so the calling tool knows the loop is ready
    rm -f "$HANDSHAKE"
done

# Final Cleanup
rm -f "$DONE_FLAG"

echo "Sudo Listener Ended"
