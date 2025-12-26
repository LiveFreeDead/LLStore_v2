#!/bin/bash

INPUT_FILE="/media/glenn/FastBackup/Git-Projects/LLStore_v2/WebLinks.ini"
LOG_FILE="$HOME/Desktop/WebLinks.log"

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: Input file not found at $INPUT_FILE"
    exit 1
fi

> "$LOG_FILE"

echo "Starting Binary-Safe Validation (7z / Gzip / TAR)..."
echo "---------------------------------------------------"

while IFS= read -r line || [[ -n "$line" ]]; do
    [[ -z "$line" || "$line" != *"|"* ]] && continue

    label="${line%%|*}"
    url="${line#*|}"
    url=$(echo "$url" | xargs)

    echo -n "Testing: $label... "

    # 1. Download first 512 bytes (TAR headers are at offset 257)
    # 2. LC_ALL=C ensures binary-safe grep
    # 3. Check for:
    #    \x37\x7a\xbc\xaf  -> 7z
    #    \x1f\x8b          -> Gzip (Standard for .tar.gz)
    #    ustar             -> The signature inside a TAR header
    if curl -sL -r 0-511 --connect-timeout 5 -m 10 "$url" | LC_ALL=C grep -aqP "\x37\x7a\xbc\xaf|\x1f\x8b|ustar"; then
        echo "OK (Valid Signature)"
    else
        curl_status=${PIPESTATUS[0]}
        
        if [[ $curl_status -ne 0 ]]; then
            echo "$label | Connection Error: $curl_status" >> "$LOG_FILE"
            echo "FAILED (Curl Code $curl_status)"
        else
            echo "$label | Invalid Content (Signature not found)" >> "$LOG_FILE"
            echo "FAILED (Header Mismatch)"
        fi
    fi

done < "$INPUT_FILE"

echo "---------------------------------------------------"
echo "Done! Results are available in $LOG_FILE"
