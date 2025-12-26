#!/bin/bash

# Define file paths
INPUT_FILE="../WebLinks.ini"
LOG_FILE="$HOME/Desktop/WebLinks.log"

# Check if the input file exists
if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: Input file not found at $INPUT_FILE"
    exit 1
fi

# Clear or create the log file
> "$LOG_FILE"

echo "Starting link validation (Header-only mode)..."
echo "--------------------------------------------"

while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines or lines without a pipe
    [[ -z "$line" || "$line" != *"|"* ]] && continue

    # Extract label and URL
    label="${line%%|*}"
    url="${line#*|}"
    url=$(echo "$url" | xargs) # Trim whitespace

    # Provide feedback to the terminal
    echo -n "Testing: $label... "

    # Use curl --head (Fetch headers only)
    # --head: Only fetch the HTTP headers
    # --silent: Don't show progress bar
    # -L: Follow redirects (important for HTTPS/URL changes)
    # --connect-timeout: Prevent hanging on dead servers
    curl --head --silent -L --connect-timeout 5 -m 10 "$url" > /dev/null
    exit_code=$?

    # Log errors
    if [[ $exit_code -ne 0 ]]; then
        echo "$label | Error Code: $exit_code" >> "$LOG_FILE"
        echo "FAILED (Code $exit_code)"
    else
        echo "OK"
    fi

done < "$INPUT_FILE"

echo "--------------------------------------------"
echo "Done! Results are available in $LOG_FILE"
