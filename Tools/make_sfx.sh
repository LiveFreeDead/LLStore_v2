#!/bin/bash
# =============================================================================
# make_sfx.sh  –  LLStore SFX Builder  (v3)
#
# Accepts a source folder or a packaged LLStore file:
#
#   Source folders or files containing:
#     LLApp.lla   LLGame.llg   ssApp.app   ppApp.app   ppGame.ppg
#
#   Packaged file types:
#     LLApp_Name.tar  / LLGame_Name.tar   (LLApp / LLGame)
#     AppName.apz                          (ssApp or ppApp – 7z container)
#     GameName.pgz                         (ppGame – 7z container)
#     AppName.app   / GameName.ppg         (bare descriptor files, zipped contents)
#
# Paths with spaces MUST be quoted:
#   ./Tools/make_sfx.sh "/path/to/My Game"
#
# Output filename:
#   Title.Version.BuildType.run   (spaces → periods)
#   Title.BuildType.run           (no version)
#
# The full Tools/ directory is bundled into every SFX.
# =============================================================================

set -euo pipefail

TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SFX_HEADER="$TOOLS_DIR/sfx-header.sh"
INSTALL_SCRIPT="$TOOLS_DIR/install.sh"
LINUX_7Z="$TOOLS_DIR/7zzs"

log() { echo "[make_sfx] $*"; }
die() { echo "[make_sfx] ERROR: $*" >&2; exit 1; }

usage() {
    cat <<EOF
Usage: $0 <source> [output_dir]

Source can be:
  A folder containing LLApp.lla / LLGame.llg / ssApp.app / ppApp.app / ppGame.ppg
  A .tar file   (LLApp or LLGame bundle)
  A .apz file   (ssApp or ppApp – 7z)
  A .pgz file   (ppGame – 7z)
  A .app file   (ssApp or ppApp descriptor)
  A .ppg file   (ppGame descriptor)

output_dir (optional):
  Directory where the .run file will be written.
  Defaults to the current working directory if not specified.

Paths with spaces must be quoted.

Output: Title.Version.BuildType.run  (spaces replaced with periods)
EOF
    exit 1
}

[ $# -lt 1 ] && usage
INPUT="$1"
OUTPUT_DIR="${2:-$PWD}"

# Sanity checks
[ -f "$SFX_HEADER" ]     || die "sfx-header.sh not found: $SFX_HEADER"
[ -f "$INSTALL_SCRIPT" ] || die "install.sh not found: $INSTALL_SCRIPT"

# ---------------------------------------------------------------------------
# Temp work dir
# ---------------------------------------------------------------------------
BUILD_TMP="$(mktemp -d /tmp/llstore_build_XXXXXX)"
trap 'rm -rf "$BUILD_TMP"' EXIT

WORK_DIR="$BUILD_TMP/myfiles"
mkdir -p "$WORK_DIR"

# ---------------------------------------------------------------------------
# INI parser (inline, no dependency on install.sh)
# ---------------------------------------------------------------------------
get_field() {
    local file="$1" section="$2" key="$3"
    local in_sec=0 line k v key_lc="${key,,}"
    [ -z "$section" ] && in_sec=1
    while IFS= read -r line; do
        line="${line%$'\r'}"
        if [[ "$line" =~ ^\[(.+)\]$ ]]; then
            local h="${BASH_REMATCH[1]}"
            if [ -z "$section" ]; then
                in_sec=0
            elif [[ "${h,,}" == "${section,,}" ]]; then
                in_sec=1
            else
                [ "$in_sec" -eq 1 ] && break; in_sec=0
            fi
            continue
        fi
        if [ "$in_sec" -eq 1 ] && [[ "$line" == *=* ]]; then
            k="${line%%=*}"; v="${line#*=}"
            k="${k,,}"; k="${k#"${k%%[![:space:]]*}"}"; k="${k%"${k##*[![:space:]]}"}"
            v="${v#"${v%%[![:space:]]*}"}"; v="${v%"${v##*[![:space:]]}"}"
            [ "$k" = "$key_lc" ] && { echo "$v"; return 0; }
        fi
    done < "$file"
    echo ""
}

# ---------------------------------------------------------------------------
# Stage 1  –  copy / extract the source into WORK_DIR
# ---------------------------------------------------------------------------
if [ -d "$INPUT" ]; then
    log "Source: folder  $INPUT"
    cp -a "$INPUT"/. "$WORK_DIR/"

elif [ -f "$INPUT" ]; then
    ext_lower="${INPUT##*.}"; ext_lower="${ext_lower,,}"
    log "Source: file (.${ext_lower})  $INPUT"
    EXTRACT_TMP="$BUILD_TMP/extract"
    mkdir -p "$EXTRACT_TMP"

    case "$ext_lower" in
        tar)
            tar xf "$INPUT" -C "$EXTRACT_TMP" \
                || die "tar extraction failed: $INPUT"
            ;;
        apz|pgz|7z)
            [ -f "$LINUX_7Z" ] || die "Tools/7zzs not found – cannot extract .$ext_lower"
            chmod +x "$LINUX_7Z" 2>/dev/null || true
            "$LINUX_7Z" x -mtc -aoa -o"$EXTRACT_TMP" "$INPUT" \
                || die "7z extraction failed: $INPUT"
            ;;
        app|ppg)
            # Bare descriptor file – the folder next to it is the source content
            local_dir="$(dirname "$INPUT")"
            log "Bare descriptor file – using parent folder: $local_dir"
            cp -a "$local_dir"/. "$EXTRACT_TMP/"
            ;;
        *)
            die "Unsupported input type: .$ext_lower"
            ;;
    esac

    # Flatten: descend into single sub-directory if present
    shopt -s dotglob nullglob
    ITEMS=("$EXTRACT_TMP"/*)
    if [ "${#ITEMS[@]}" -eq 1 ] && [ -d "${ITEMS[0]}" ]; then
        cp -a "${ITEMS[0]}"/. "$WORK_DIR/"
    else
        cp -a "$EXTRACT_TMP"/. "$WORK_DIR/"
    fi
    shopt -u dotglob nullglob

else
    die "Input not found: $INPUT"
fi

# ---------------------------------------------------------------------------
# Stage 2  –  locate the metadata file
# ---------------------------------------------------------------------------
LLFILE=""
for cand in \
    "$WORK_DIR/LLApp.lla"  "$WORK_DIR/LLGame.llg" \
    "$WORK_DIR/ssApp.app"  "$WORK_DIR/ppApp.app"  "$WORK_DIR/ppGame.ppg" \
    "$WORK_DIR"/*.lla      "$WORK_DIR"/*.llg \
    "$WORK_DIR"/*.app      "$WORK_DIR"/*.ppg; do
    [ -f "$cand" ] && { LLFILE="$cand"; break; }
done

[ -n "$LLFILE" ] || die "No LLFile metadata (*.lla / *.llg / *.app / *.ppg) found."
log "LLFile: $LLFILE"

# Determine INI section based on extension
LLFILE_EXT="${LLFILE##*.}"; LLFILE_EXT="${LLFILE_EXT,,}"
case "$LLFILE_EXT" in
    app|ppg) INI_SECTION="SetupS" ;;
    *)       INI_SECTION="LLFile" ;;
esac
log "INI section: [$INI_SECTION]"

# ---------------------------------------------------------------------------
# Stage 3  –  parse Title, Version, BuildType
# ---------------------------------------------------------------------------
TITLE="$(get_field "$LLFILE" "$INI_SECTION" "Title")"
[ -n "$TITLE" ] || die "Title= not found in $LLFILE"

VERSION="$(get_field     "$LLFILE" "$INI_SECTION" "Version")"
BUILD_TYPE="$(get_field  "$LLFILE" "$INI_SECTION" "BuildType")"

# Infer BuildType from extension when not set in file
if [ -z "$BUILD_TYPE" ]; then
    case "$LLFILE_EXT" in
        llg) BUILD_TYPE="LLGame" ;;
        lla) BUILD_TYPE="LLApp"  ;;
        ppg) BUILD_TYPE="ppGame" ;;
        app)
            local_bt="$(get_field "$LLFILE" "SetupS" "BuildType")"
            BUILD_TYPE="${local_bt:-ssApp}"
            ;;
    esac
fi

log "Title:     $TITLE"
log "Version:   ${VERSION:-(none)}"
log "BuildType: $BUILD_TYPE"

# ---------------------------------------------------------------------------
# Stage 4  –  bundle Tools/ into WORK_DIR  (allowlist – only needed files)
#
# Allowlist rationale:
#   install.sh      – core installer (always)
#   sfx-header.sh   – SFX self-extractor header (always)
#   make_sfx.sh     – bundled for reference / rebuild capability (always)
#   7zzs            – Linux 7z binary used for extraction (always)
#   7z.exe/7z.dll   – Wine 7z binaries (ppGame / ppApp / ssApp builds only)
#   LinuxMenuSorting/ – XDG menu sorting, used by apply_menu_sorting() (always)
#   run-1080p       – helper script that may be called from LLScript.sh (always)
#
# Everything else in Tools/ (hicolor, curl, wget, *.exe other than 7z.exe,
# Menus/KazzMenu, Menus/LastOSMenu, *.ini catalogues, etc.) is intentionally
# excluded so future additions to Tools/ do not silently bloat SFX output.
# ---------------------------------------------------------------------------
log "Bundling Tools/ (allowlist)..."

DEST_TOOLS="$WORK_DIR/Tools"
mkdir -p "$DEST_TOOLS"

# ── Core scripts (always overwrite so the SFX always ships the latest) ───────
cp -f "$INSTALL_SCRIPT" "$DEST_TOOLS/install.sh"
cp -f "$SFX_HEADER"     "$DEST_TOOLS/sfx-header.sh"
cp -f "$0"              "$DEST_TOOLS/make_sfx.sh"

# LLScript_Core.sh / LLScript_Sudo_Core.sh are NOT bundled as loose files.
# Instead, they are inlined directly into any LLScript.sh / LLScript_Sudo.sh
# found in the package (see inline_core below).  This means SFX installers
# have zero external dependency on a host LLStore installation.

# ── Linux 7z binary (always needed for extraction) ──────────────────────────
[ -f "$TOOLS_DIR/7zzs" ] && cp -f "$TOOLS_DIR/7zzs" "$DEST_TOOLS/" || true

# ── run-1080p helper (may be called from user LLScript.sh) ──────────────────
[ -f "$TOOLS_DIR/run-1080p" ] && cp -f "$TOOLS_DIR/run-1080p" "$DEST_TOOLS/" || true

# ── Wine 7z binaries (ppGame / ppApp / ssApp builds only) ───────────────────
case "$BUILD_TYPE" in
    ppGame|ppApp|ssApp)
        for f in "$TOOLS_DIR/7z.exe" "$TOOLS_DIR/7z.dll"; do
            [ -f "$f" ] && cp -f "$f" "$DEST_TOOLS/" || true
        done
        ;;
esac

# ── LinuxMenuSorting subdirectory (used by apply_menu_sorting in install.sh) ─
if [ -d "$TOOLS_DIR/LinuxMenuSorting" ]; then
    cp -a "$TOOLS_DIR/LinuxMenuSorting" "$DEST_TOOLS/"
else
    log "Warning: LinuxMenuSorting not found in $TOOLS_DIR – menu sorting will be skipped."
fi

# Ensure everything is executable
[ -f "$DEST_TOOLS/7zzs" ]   && chmod +x "$DEST_TOOLS/7zzs"   || true
[ -f "$DEST_TOOLS/7z.exe" ] && chmod +x "$DEST_TOOLS/7z.exe" || true
find "$DEST_TOOLS" -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# ---------------------------------------------------------------------------
# Stage 4b  –  inline LLScript_Core.sh / LLScript_Sudo_Core.sh into user
#              scripts at build time.
#
# Why inline rather than bundle loose files?
# • SFX installers run on systems that have NO LLStore installation.
# • Sourcing from /LastOS/LLStore/Tools/ is not reliable in that context.
# • Bundling loose core files + a runtime search chain is fragile spaghetti.
# • Inlining is deterministic: the script is always self-contained.
#
# How it works:
#   Any .sh file in the work directory whose source-line ends with the
#   comment "#LLCore" (the marker LLStore writes into user scripts) has
#   that entire line replaced with the content of the matching core script.
#   Non-SFX scripts (run from a live LLStore install) never hit this path
#   because make_sfx.sh is only called when building an SFX.
# ---------------------------------------------------------------------------

inline_core() {
    local script="$1" core="$2"
    [ -f "$script" ] || return 0
    if [ ! -f "$core" ]; then
        log "Warning: $(basename "$core") not found – core NOT inlined in $(basename "$script")."
        return 0
    fi

    # Core content: skip the shebang line so we don't get a double #!/bin/bash
    local core_content
    core_content="$(tail -n +2 "$core")"

    local tmp="${script}.sfx_inline_tmp"
    local inlined=0

    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" == *"#LLCore"* ]]; then
            printf '# vvv LLCore inlined by make_sfx at build time – no external dependency vvv\n'
            printf '%s\n' "$core_content"
            printf '# ^^^ End inlined LLCore ^^^\n'
            inlined=$(( inlined + 1 ))
        else
            printf '%s\n' "$line"
        fi
    done < "$script" > "$tmp"

    mv "$tmp" "$script"
    chmod +x "$script"

    if [ "$inlined" -gt 0 ]; then
        log "  Inlined $(basename "$core") into $(basename "$script") ($inlined occurrence(s))"
    else
        log "  Warning: #LLCore marker not found in $(basename "$script") – nothing inlined."
    fi
}

log "Inlining core scripts into user scripts..."
CORE_USER="$TOOLS_DIR/LLScript_Core.sh"
CORE_SUDO="$TOOLS_DIR/LLScript_Sudo_Core.sh"

# Check all .sh files in the work dir root (user scripts live alongside the LLFile)
for sh_file in "$WORK_DIR"/*.sh; do
    [ -f "$sh_file" ] || continue
    case "$(basename "$sh_file")" in
        LLScript_Sudo.sh) inline_core "$sh_file" "$CORE_SUDO" ;;
        LLScript.sh)      inline_core "$sh_file" "$CORE_USER" ;;
        *)
            # Any other .sh that carries a #LLCore marker gets the user core by convention
            if grep -q "#LLCore" "$sh_file" 2>/dev/null; then
                log "  Found #LLCore in $(basename "$sh_file") – applying user core"
                inline_core "$sh_file" "$CORE_USER"
            fi
            ;;
    esac
done

# ---------------------------------------------------------------------------
# Stage 5  –  output filename
# ---------------------------------------------------------------------------
SAFE_TITLE="${TITLE// /.}"
SAFE_VER="${VERSION// /.}"
SAFE_BT="${BUILD_TYPE// /.}"

if [ -n "$SAFE_VER" ]; then
    OUTPUT_NAME="${SAFE_TITLE}.${SAFE_VER}.${SAFE_BT}.run"
else
    OUTPUT_NAME="${SAFE_TITLE}.${SAFE_BT}.run"
fi
log "Output: $OUTPUT_NAME"

# ---------------------------------------------------------------------------
# Stage 6  –  create the tar.gz payload
# ---------------------------------------------------------------------------
TAR_FILE="$BUILD_TMP/payload.tar.gz"
log "Archiving payload..."
tar czf "$TAR_FILE" -C "$BUILD_TMP" myfiles/ \
    || die "tar failed creating payload."

# ---------------------------------------------------------------------------
# Stage 7  –  assemble SFX
# ---------------------------------------------------------------------------
OUTPUT_PATH="$OUTPUT_DIR/$OUTPUT_NAME"
log "Building SFX: $OUTPUT_PATH"
cat "$SFX_HEADER" "$TAR_FILE" > "$OUTPUT_PATH" || die "SFX assembly failed."
chmod +x "$OUTPUT_PATH"             || die "chmod +x failed."

SIZE="$(du -sh "$OUTPUT_PATH" | cut -f1)"
log ""
log "=================================================="
log " SFX created: $OUTPUT_PATH"
log " BuildType:   $BUILD_TYPE"
log " Size:        $SIZE"
log "=================================================="
log " Run with:  ./$OUTPUT_NAME"
log ""
