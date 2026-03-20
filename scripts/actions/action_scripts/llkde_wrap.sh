#!/bin/bash
# llkde_wrap.sh — KDE/Dolphin multi-file wrapper for LLStore context menu actions.
#
# KDE passes all selected files as separate arguments to Exec= in one shot,
# e.g. "llkde_wrap.sh -c file1 file2 file3".  LLStore only accepts one path
# per invocation, so this script loops and dispatches each file individually.
#
# Usage:  llkde_wrap.sh FLAG FILE [FILE ...]
#   FLAG  one of: -i  -e  -c  -b  -x
#         -i  Install with LLFile   (calls llfile -i)
#         -e  Edit in LLFile Editor (calls llfile -e)
#         -c  Compress as LLFile    (calls llfile -c)
#         -b  Build as LLFile       (calls llfile -b)
#         -x  Extract LLFile archive (calls llextract.sh, located alongside this script)
#
# The script is deployed to:
#   ~/.local/share/kio/servicemenus/action_scripts/llkde_wrap.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FLAG="$1"
shift

if [ -z "$FLAG" ] || [ $# -eq 0 ]; then
    echo "Usage: llkde_wrap.sh FLAG FILE [FILE ...]" >&2
    exit 1
fi

for f in "$@"; do
    case "$FLAG" in
        -x)
            bash "$SCRIPT_DIR/llextract.sh" "$f"
            ;;
        -i|-e|-c|-b)
            env GDK_BACKEND=x11 llfile "$FLAG" "$f"
            ;;
        *)
            echo "Unknown flag: $FLAG" >&2
            exit 1
            ;;
    esac
done

exit 0
