#!/bin/bash
# =============================================================================
# patch-build.sh  -  Post-build execstack fix
# -----------------------------------------------------------------------------
# Run this on Linux Mint after every project build before writing to USB.
# Clears the executable stack flag from the Xojo .so libs so the files run
# on OpenSUSE without needing any runtime workarounds.
# The fix is permanent in the ELF headers.
#
# Usage:  bash patch-build.sh
# =============================================================================

# ---------------------------------------------------------------------------
# Set to true to also patch the llstore binary itself.
# Leave false unless you have a specific reason — the libs are all that's
# needed, and llstore itself is rarely rebuilt.
# ---------------------------------------------------------------------------
PATCH_BINARY=false

# ---------------------------------------------------------------------------
# Explicit list of lib files to patch in "llstore Libs"
# ---------------------------------------------------------------------------
PATCH_LIBS=(
    "libc++.so.1"
    "libgthread-2.0.so.0"
    "libGZip64.so"
    "libRBCrypto64.so"
    "libRBInternetEncodings64.so"
    "libRBRegEx64.so"
    "libRBShell64.so"
    "libunwind.so.8"
    "libunwind-x86_64.so.8"
    "XojoGUIFramework64.so"
)

# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIBS_DIR="$SCRIPT_DIR/llstore Libs"
BINARY="$SCRIPT_DIR/llstore"

echo
echo "==> patch-build.sh"
echo

# ---------------------------------------------------------------------------
# Check we're in the right place
# ---------------------------------------------------------------------------
if [[ ! -d "$LIBS_DIR" ]]; then
    echo "ERROR: 'llstore Libs' folder not found at: $LIBS_DIR"
    echo "       Run this script from the same folder as llstore and setup.sh."
    exit 1
fi

# ---------------------------------------------------------------------------
# Install patchelf if missing
# ---------------------------------------------------------------------------
if ! command -v patchelf &>/dev/null; then
    echo "patchelf not found — installing (sudo required)..."
    sudo apt-get install -y patchelf
    if ! command -v patchelf &>/dev/null; then
        echo "ERROR: patchelf install failed."
        exit 1
    fi
    echo
fi

# ---------------------------------------------------------------------------
# Optionally patch the llstore binary
# ---------------------------------------------------------------------------
if [[ "$PATCH_BINARY" == "true" ]]; then
    if [[ ! -f "$BINARY" ]]; then
        echo "WARNING: llstore binary not found at: $BINARY — skipping."
    else
        echo "Patching binary..."
        if patchelf --clear-execstack "$BINARY" 2>/dev/null; then
            echo "  OK: llstore"
        else
            echo "  SKIP: llstore (already clean or not a valid ELF file)"
        fi
        echo
    fi
else
    echo "Skipping llstore binary (PATCH_BINARY=false)"
    echo
fi

# ---------------------------------------------------------------------------
# Patch the explicit lib list
# ---------------------------------------------------------------------------
echo "Patching libs..."
PATCHED=0
SKIPPED=0
MISSING=0
for LIB in "${PATCH_LIBS[@]}"; do
    LIBPATH="$LIBS_DIR/$LIB"
    if [[ ! -f "$LIBPATH" ]]; then
        echo "  MISSING: $LIB"
        (( MISSING++ ))
    elif patchelf --clear-execstack "$LIBPATH" 2>/dev/null; then
        echo "  OK: $LIB"
        (( PATCHED++ ))
    else
        echo "  SKIP: $LIB (already clean or not a valid ELF file)"
        (( SKIPPED++ ))
    fi
done

echo
echo "==> Done. Patched: $PATCHED  Already clean: $SKIPPED  Missing: $MISSING"
[[ $MISSING -eq 0 ]] && echo "    Safe to write to USB." || echo "    WARNING: $MISSING file(s) not found — check the list above."
echo
