#!/bin/bash

TARGET_NAME="llstore"
STOP_FILE="/tmp/stopLLStore"
EXEC_PATH=""

#Cleanup previous stop
rm -f "$STOP_FILE"

echo "Monitor started. Waiting for initial $TARGET_NAME process to capture path..."

while true; do
    # 1. Check for the stop file immediately
    if [[ -f "$STOP_FILE" ]]; then
        echo "Stop file $STOP_FILE detected. Deleting file and exiting."
        rm -f "$STOP_FILE"
        exit 0
    fi

    # 2. Try to get the PID
    PID=$(pgrep -x "$TARGET_NAME" | head -1)

    if [[ -n "$PID" ]]; then
        # If we haven't captured the path yet, get it from the running process
        if [[ -z "$EXEC_PATH" ]]; then
            EXEC_PATH=$(readlink -f /proc/"$PID"/exe)
            echo "Captured path from running process: $EXEC_PATH"
        fi
    else
        # 3. Process is closed, check if we have a path to restart it
        if [[ -n "$EXEC_PATH" ]]; then
            echo "$TARGET_NAME is down. Restarting with -continue flag..."
            
            # Executing with the requested argument
            "$EXEC_PATH" -continue &
            
            # Brief sleep to allow the new process to initialize
            sleep 1
        else
            echo "Waiting for $TARGET_NAME to be started manually once to capture path..."
        fi
    fi

    # 4. Sleep to prevent high CPU usage
    sleep 2
done
