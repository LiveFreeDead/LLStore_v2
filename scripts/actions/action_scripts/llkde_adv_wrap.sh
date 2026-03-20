#!/bin/bash
# llkde_adv_wrap.sh — KDE/Dolphin wrapper for LLFile Advanced context menu scripts.
#
# The Advanced scripts were written for Nemo/Nautilus which either pass files as
# positional args ($@) or via NEMO_SCRIPT_SELECTED_FILE_PATHS / NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
# env vars.  This wrapper sets both env vars from the KDE-supplied args so every
# script works correctly regardless of which mechanism it uses.
#
# Usage:  llkde_adv_wrap.sh "Script Name" FILE [FILE ...]
#   $1   exact filename of the script inside kde_advanced/ (may contain spaces)
#   $2+  selected file paths passed by KDE via %F

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT_NAME="$1"
shift

if [ -z "$SCRIPT_NAME" ] || [ $# -eq 0 ]; then
    echo "Usage: llkde_adv_wrap.sh SCRIPT_NAME FILE [FILE ...]" >&2
    exit 1
fi

SCRIPT_PATH="$SCRIPT_DIR/kde_advanced/$SCRIPT_NAME"
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Advanced script not found: $SCRIPT_PATH" >&2
    exit 1
fi

# Build newline-separated path list that Nemo/Nautilus-style scripts expect
NL_PATHS="$(printf '%s\n' "$@")"
export NEMO_SCRIPT_SELECTED_FILE_PATHS="$NL_PATHS"
export NAUTILUS_SCRIPT_SELECTED_FILE_PATHS="$NL_PATHS"

exec bash "$SCRIPT_PATH" "$@"
