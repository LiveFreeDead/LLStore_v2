#!/bin/bash
# =============================================================================
# LLStore SFX Installer - install.sh  (v3)
#
# Supports:  LLApp (.lla)  LLGame (.llg)  ssApp (.app)  ppApp (.app)  ppGame (.ppg)
# Archives:  LLApp.tar / LLGame.tar / ppApp.7z / ppGame.7z / Patch.7z
# Shortcuts: [Title.desktop]  [Title.lnk]  (lnk → .desktop + wine wscript)
# Scripts:   LLScript.sh  LLScript_Sudo.sh  BuildType.cmd  BuildType.reg
#
# Logging:   All output tee'd to $HOME/Desktop/LLStore_Error.log
# Sudo:      Requested only when target path is not writable by current user.
#            LLScript_Sudo.sh run via sudo -E with full env export preamble.
# =============================================================================

# Ensure USER and HOME are always bound
USER="${USER:-$(id -un 2>/dev/null || echo "user")}"
HOME="${HOME:-/root}"
export USER HOME

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
TOOLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SFX_ROOT="$(dirname "$TOOLS_DIR")"
LINUX_7Z="$TOOLS_DIR/7zzs"
WINE_7Z="$TOOLS_DIR/7z.exe"

# Default install roots (user can override via env before running)
LL_GAMES_ROOT="${LL_GAMES_ROOT:-$HOME/LLGames}"
LL_APPS_ROOT="${LL_APPS_ROOT:-$HOME/LLApps}"
PP_GAMES_ROOT="${PP_GAMES_ROOT:-$HOME/.wine/drive_c/ppGames}"
PP_APPS_ROOT="${PP_APPS_ROOT:-$HOME/.wine/drive_c/ppApps}"
SS_APPS_ROOT="${SS_APPS_ROOT:-$HOME/.wine/drive_c/ssApps}"
export LL_GAMES_ROOT LL_APPS_ROOT PP_GAMES_ROOT PP_APPS_ROOT SS_APPS_ROOT

# Working temp dir
INSTALL_TMP="$HOME/.lltemp/CLI-Installer/install-$$"
mkdir -p "$INSTALL_TMP"
# Make temp dirs world-readable so sudo processes can access them
chmod 755 "$INSTALL_TMP" "$HOME/.lltemp" "$HOME/.lltemp/CLI-Installer" 2>/dev/null || true

cleanup() {
    rm -rf "$HOME/.lltemp/CLI-Installer"
    rmdir "$HOME/.lltemp" 2>/dev/null || true
}
trap 'cleanup' EXIT

# ---------------------------------------------------------------------------
# Desktop log paths – files are only written when there is an error/warning.
# During a clean run nothing appears on the Desktop.
# ---------------------------------------------------------------------------
DESKTOP_LOG="$HOME/Desktop/LLStore_Error.log"
DESKTOP_SCRIPT_LOG="$HOME/Desktop/LLStore_Script_Expanded.log"
mkdir -p "$HOME/Desktop" 2>/dev/null || true

LOG_FILE="$INSTALL_TMP/install.log"
# Internal expanded-script staging area (copied to Desktop only on error)
SCRIPT_EXPANDED_TMP="$INSTALL_TMP/script_expanded.log"

# Set to 1 the first time warn/error is called; triggers Desktop flush at exit.
_HAD_ISSUE=0

_flush_to_desktop() {
    # Copy the internal log to the Desktop log files (called on first issue).
    [ "$_HAD_ISSUE" -eq 1 ] && return 0   # already flushed header once
    _HAD_ISSUE=1
    {
        echo "======================================================"
        echo " LLStore SFX Installer  –  $(date)"
        echo "======================================================"
        cat "$LOG_FILE" 2>/dev/null || true
    } > "$DESKTOP_LOG" 2>/dev/null || DESKTOP_LOG="/dev/null"
}

# After the first issue, every subsequent _log_raw also appends to Desktop.
_log_raw() {
    local line="$*"
    echo "$line"
    echo "$line" >> "$LOG_FILE" 2>/dev/null || true
    if [ "$_HAD_ISSUE" -eq 1 ]; then
        echo "$line" >> "$DESKTOP_LOG" 2>/dev/null || true
    fi
}
log()   { _log_raw "[INFO]  $*"; }
warn()  { _flush_to_desktop; _log_raw "[WARN]  $*"; }
error() { _flush_to_desktop; _log_raw "[ERROR] $*"; }

# Capture a command's combined stdout+stderr to both logs
_tee_run() {
    "$@" 2>&1 | while IFS= read -r l; do _log_raw "        $l"; done
    return "${PIPESTATUS[0]}"
}

# ---------------------------------------------------------------------------
# Terminal detection
# ---------------------------------------------------------------------------
in_terminal() { [ -t 0 ] && [ -t 1 ]; }

# ---------------------------------------------------------------------------
# Privilege escalation
# ---------------------------------------------------------------------------
SUDO_CMD=""
SUDO_FOUND=false

find_sudo() {
    $SUDO_FOUND && return 0
    SUDO_FOUND=true
    if [ "$EUID" -eq 0 ]; then
        SUDO_CMD="root"; return 0
    fi
    for c in sudo pkexec doas kdesu gksu kdesudo; do
        if command -v "$c" &>/dev/null; then
            SUDO_CMD="$c"
            log "Privilege tool: $SUDO_CMD"
            return 0
        fi
    done
    warn "No privilege escalation tool found."
    SUDO_CMD=""
}

run_sudo() {
    local cmd="$*"
    find_sudo
    [ -z "$SUDO_CMD" ] && { warn "Skipping (no sudo): $cmd"; return 1; }
    case "$SUDO_CMD" in
        root)    bash -c "$cmd" ;;
        sudo)    sudo -E bash -c "$cmd" ;;
        pkexec)  pkexec env HOME="$HOME" USER="$USER" PATH="$PATH" \
                     XDG_SESSION_DESKTOP="${XDG_SESSION_DESKTOP:-}" \
                     XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP:-}" \
                     DISPLAY="${DISPLAY:-}" \
                     WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-}" \
                     LL_GAMES_ROOT="$LL_GAMES_ROOT" \
                     LL_APPS_ROOT="$LL_APPS_ROOT" \
                     PP_GAMES_ROOT="$PP_GAMES_ROOT" \
                     PP_APPS_ROOT="$PP_APPS_ROOT" \
                     SS_APPS_ROOT="$SS_APPS_ROOT" \
                     bash -c "$cmd" ;;
        doas)    doas -E bash -c "$cmd" ;;
        *)       "$SUDO_CMD" -c "$cmd" ;;
    esac
}

# ---------------------------------------------------------------------------
# Writable-path helper  – returns 0 (true) if sudo IS needed
# ---------------------------------------------------------------------------
path_needs_sudo() {
    [ "$EUID" -eq 0 ] && return 1
    local p="$1"
    while [ ! -e "$p" ]; do
        local par; par="$(dirname "$p")"
        [ "$par" = "$p" ] && return 0
        p="$par"
    done
    [ -w "$p" ] && return 1
    return 0
}

make_dir() {
    local dir="$1"
    if path_needs_sudo "$dir"; then
        find_sudo
        if [ -n "$SUDO_CMD" ]; then
            run_sudo "mkdir -p '$dir'" 2>&1 | while IFS= read -r l; do _log_raw "        $l"; done \
                || warn "sudo mkdir failed: $dir"
        else
            warn "Cannot create $dir – no sudo."
        fi
    else
        mkdir -p "$dir" || warn "mkdir failed: $dir"
    fi
}

copy_file() {
    local src="$1" dest_dir="$2"
    [ -f "$src" ] || return 0
    local dest_file="$dest_dir/$(basename "$src")"
    if path_needs_sudo "$dest_dir"; then
        find_sudo
        if [ -n "$SUDO_CMD" ]; then
            run_sudo "cp -f '$src' '$dest_file' && chmod 644 '$dest_file'" \
                2>&1 | while IFS= read -r l; do _log_raw "        $l"; done \
                || warn "sudo cp failed: $src"
        else
            warn "Cannot copy to $dest_dir – no sudo."
        fi
    else
        cp -f "$src" "$dest_file" 2>/dev/null || warn "cp failed: $src"
        chmod 644 "$dest_file" 2>/dev/null || true
    fi
}

# ---------------------------------------------------------------------------
# INI / LLFile parser  –  handles [LLFile] and [SetupS]
# ---------------------------------------------------------------------------
get_field() {
    local file="$1" section="$2" key="$3"
    local in_sec=0 line key_lc val k
    key_lc="${key,,}"
    [ -z "$section" ] && in_sec=1
    while IFS= read -r line; do
        line="${line%$'\r'}"
        if [[ "$line" =~ ^\[(.+)\]$ ]]; then
            local hdr="${BASH_REMATCH[1]}"
            if [ -z "$section" ]; then
                in_sec=0
            elif [[ "${hdr,,}" == "${section,,}" ]]; then
                in_sec=1
            else
                [ "$in_sec" -eq 1 ] && break
                in_sec=0
            fi
            continue
        fi
        if [ "$in_sec" -eq 1 ] && [[ "$line" == *=* ]]; then
            k="${line%%=*}"; val="${line#*=}"
            k="${k,,}"; k="${k#"${k%%[![:space:]]*}"}"; k="${k%"${k##*[![:space:]]}"}"
            val="${val#"${val%%[![:space:]]*}"}"; val="${val%"${val##*[![:space:]]}"}"
            if [ "$k" = "$key_lc" ]; then echo "$val"; return 0; fi
        fi
    done < "$file"
    echo ""
}

# ---------------------------------------------------------------------------
# Flag helper  (space/semicolon-delimited Flags= field)
# ---------------------------------------------------------------------------
has_flag() {
    local flags="${1,,}" flag="${2,,}"
    flags="${flags//;/ }"
    [[ " $flags " == *" $flag "* ]]
}

# ---------------------------------------------------------------------------
# Path expansion  – Linux native
# ---------------------------------------------------------------------------
expand_path() {
    local p="$1" ap="${2:-}"
    p="${p//%LLGames%/$LL_GAMES_ROOT}"
    p="${p//%LLApps%/$LL_APPS_ROOT}"
    p="${p//%ppGames%/$PP_GAMES_ROOT}"
    p="${p//%ppApps%/$PP_APPS_ROOT}"
    p="${p//%ssApps%/$SS_APPS_ROOT}"
    p="${p//%AppPath%/$ap}"
    p="${p//%Desktop%/$HOME/Desktop}"
    p="${p//%UserProfile%/$HOME}"
    p="${p//%HomeDrive%/$HOME/.wine/drive_c}"
    p="${p//%SystemDrive%/$HOME/.wine/drive_c}"
    p="${p//%SystemRoot%/$HOME/.wine/drive_c/windows}"
    p="${p//%WinDir%/$HOME/.wine/drive_c/windows}"
    p="${p//%SystemDir%/$HOME/.wine/drive_c/windows/System32}"
    p="${p//%ProgramFiles%/$HOME/.wine/drive_c/Program Files}"
    p="${p//%ProgramFiles(x86)%/$HOME/.wine/drive_c/Program Files (x86)}"
    p="${p//%CommonProgramFiles%/$HOME/.wine/drive_c/Program Files/Common Files}"
    p="${p//%ProgramData%/$HOME/.wine/drive_c/ProgramData}"
    p="${p//%AppDataCommon%/$HOME/.wine/drive_c/ProgramData}"
    p="${p//%AllUsersProfile%/$HOME/.wine/drive_c/Users/Public}"
    p="${p//%AppData%/$HOME/.wine/drive_c/users/$USER/AppData/Roaming}"
    p="${p//%LocalAppData%/$HOME/.wine/drive_c/users/$USER/AppData/Local}"
    p="${p//%UserName%/$USER}"
    p="${p//%Extract%/$LINUX_7Z -mtc -aoa x}"
    p="${p//\$HOME/$HOME}"
    p="${p//\\/\/}"          # backslash → forward slash
    echo "$p"
}

# ---------------------------------------------------------------------------
# Path expansion  – Wine / Windows (preserves drive letters, uses backslashes)
# ---------------------------------------------------------------------------
_to_wine_path() {
    # Convert a Linux path to a wine z: path (z:\ is the root)
    local lp="$1"
    if [[ "$lp" == "$HOME/.wine/drive_c"* ]]; then
        local rel="${lp#"$HOME/.wine/drive_c"}"
        rel="${rel//\//\\}"
        echo "C:${rel}"
    else
        echo "z:${lp//\//\\}"
    fi
}

expand_path_wine() {
    local p="$1" ap="${2:-}"
    local wp_ppg; wp_ppg="$(_to_wine_path "$PP_GAMES_ROOT")"
    local wp_ppa; wp_ppa="$(_to_wine_path "$PP_APPS_ROOT")"
    local wp_ap;  wp_ap="$(_to_wine_path "$ap")"
    p="${p//%LLGames%/z:${LL_GAMES_ROOT//\//\\}}"
    p="${p//%LLApps%/z:${LL_APPS_ROOT//\//\\}}"
    p="${p//%ppGames%/$wp_ppg}"
    p="${p//%ppApps%/$wp_ppa}"
    p="${p//%ssApps%/$wp_ppa}"
    p="${p//%AppPath%/$wp_ap}"
    p="${p//%Desktop%/z:${HOME//\//\\}\\Desktop}"
    p="${p//%UserProfile%/z:${HOME//\//\\}}"
    p="${p//%HomeDrive%/C:}"
    p="${p//%SystemDrive%/C:}"
    p="${p//%SystemRoot%/C:\\windows}"
    p="${p//%WinDir%/C:\\windows}"
    p="${p//%SystemDir%/C:\\windows\\System32}"
    p="${p//%ProgramFiles%/C:\\Program Files}"
    p="${p//%ProgramFiles(x86)%/C:\\Program Files (x86)}"
    p="${p//%CommonProgramFiles%/C:\\Program Files\\Common Files}"
    p="${p//%ProgramData%/C:\\ProgramData}"
    p="${p//%AppDataCommon%/C:\\ProgramData}"
    p="${p//%AllUsersProfile%/C:\\Users\\Public}"
    p="${p//%UserName%/$USER}"
    p="${p//%AppData%/C:\\users\\$USER\\AppData\\Roaming}"
    p="${p//%LocalAppData%/C:\\users\\$USER\\AppData\\Local}"
    p="${p//%Extract%/z:${WINE_7Z//\//\\} -mtc -aoa x}"
    echo "$p"
}

expand_script_file() {
    local src="$1" ap="$2"
    local dst="$INSTALL_TMP/expanded_$(basename "$src")"
    # NOTE: '|| [[ -n "$line" ]]' handles files whose last line has no trailing
    # newline – read() returns non-zero at EOF but $line still holds the content.
    # Without this, the final line (e.g. 'inst merkuro') is silently dropped.
    while IFS= read -r line || [[ -n "$line" ]]; do
        printf '%s\n' "$(expand_path "$line" "$ap")"
    done < "$src" > "$dst"
    echo "$dst"
}

expand_reg_file() {
    local src="$1" ap="$2"
    local dst="$INSTALL_TMP/expanded_$(basename "$src").reg"
    while IFS= read -r line || [[ -n "$line" ]]; do
        printf '%s\n' "$(expand_path_wine "$line" "$ap")"
    done < "$src" > "$dst"
    echo "$dst"
}

expand_cmd_file() {
    local src="$1" ap="$2"
    local dst="$INSTALL_TMP/expanded_$(basename "$src").cmd"
    while IFS= read -r line || [[ -n "$line" ]]; do
        printf '%s\n' "$(expand_path_wine "$line" "$ap")"
    done < "$src" > "$dst"
    echo "$dst"
}

# ---------------------------------------------------------------------------
# Extraction helpers
# ---------------------------------------------------------------------------
_ensure_7z() {
    [ ! -x "$LINUX_7Z" ] && chmod +x "$LINUX_7Z" 2>/dev/null || true
    [ -x "$LINUX_7Z" ] || { error "Tools/7zzs not executable."; return 1; }
}

_do_extract() {
    local archive="$1" dest="$2"
    case "${archive,,}" in
        *.tar.gz|*.tgz)
            tar xzf "$archive" -C "$dest" 2>&1 | while IFS= read -r l; do _log_raw "        $l"; done
            return "${PIPESTATUS[0]}"
            ;;
        *.tar)
            tar xf  "$archive" -C "$dest" 2>&1 | while IFS= read -r l; do _log_raw "        $l"; done
            return "${PIPESTATUS[0]}"
            ;;
        *.7z|*.apz|*.pgz)
            _ensure_7z || return 1
            "$LINUX_7Z" x -mtc -aoa -o"$dest" "$archive" 2>&1 \
                | while IFS= read -r l; do _log_raw "        $l"; done
            return "${PIPESTATUS[0]}"
            ;;
        *)
            warn "Unknown archive type: $archive – trying 7zzs"
            _ensure_7z || return 1
            "$LINUX_7Z" x -mtc -aoa -o"$dest" "$archive" 2>&1 \
                | while IFS= read -r l; do _log_raw "        $l"; done
            return "${PIPESTATUS[0]}"
            ;;
    esac
}

extract_archive() {
    local archive="$1" dest="$2"
    log "Extracting: $(basename "$archive") -> $dest"
    if path_needs_sudo "$dest"; then
        local tmp_dest="$INSTALL_TMP/xtr_$$"
        mkdir -p "$tmp_dest"
        if _do_extract "$archive" "$tmp_dest"; then
            find_sudo
            if [ -n "$SUDO_CMD" ]; then
                log "  (sudo) moving extracted files into $dest"
                run_sudo "mkdir -p '$dest' && cp -a '$tmp_dest/.' '$dest/'" \
                    2>&1 | while IFS= read -r l; do _log_raw "        $l"; done \
                    || warn "sudo copy of extracted content failed."
            else
                warn "Cannot write to $dest – no sudo."
            fi
        else
            warn "Extraction failed: $archive"
        fi
        rm -rf "$tmp_dest"
    else
        mkdir -p "$dest"
        _do_extract "$archive" "$dest" || warn "Extraction failed: $archive"
    fi
}

# ---------------------------------------------------------------------------
# Find metadata file
# ---------------------------------------------------------------------------
find_llfile() {
    local f
    for f in \
        "$SFX_ROOT/LLApp.lla"  "$SFX_ROOT/LLGame.llg" \
        "$SFX_ROOT/ssApp.app"  "$SFX_ROOT/ppApp.app"  "$SFX_ROOT/ppGame.ppg" \
        "$SFX_ROOT"/*.lla      "$SFX_ROOT"/*.llg \
        "$SFX_ROOT"/*.app      "$SFX_ROOT"/*.ppg; do
        [ -f "$f" ] && { echo "$f"; return 0; }
    done
    error "No LLFile metadata found in $SFX_ROOT"
    return 1
}

llfile_section() {
    case "${1,,}" in *.app|*.ppg) echo "SetupS" ;; *) echo "LLFile" ;; esac
}

# ---------------------------------------------------------------------------
# XDG category helpers
#
# When a [Title.desktop] section in the LLFile has no Categories= line,
# install.sh derives a proper XDG Categories= string from the LLFile's
# top-level Category= / Catalog= field and the BuildType.
#
# This avoids the need to bundle Category.ini or MenuCatalog*.ini into the
# SFX — the mapping is embedded here for all common cases.
# ---------------------------------------------------------------------------

# Map a single catalog token to its XDG *base* category group.
_xdg_base_for_cat() {
    case "${1,,}" in
        # Games – any token ending in "game" or bare "game"
        *game|game)                                                    echo "Game"        ;;
        # Disk / file management / system tools
        filemanager|filesystem|filetools|filetransfer|disk|archiving|\
        compression|recovery|administration|hardwaresettings|\
        packagemanager|terminalemulator|accessibility|system|utility|\
        settings|preferences|security|theme|desktopsettings)          echo "System"      ;;
        # Audio / Video
        audio|audiov*|soundvideo|music|player|recorder|midi|mixer|\
        sequencer|video|videoc*|tv|tuner)                              echo "AudioVideo"  ;;
        # Graphics
        graphics|raster*|vector*|imageprocessing|photography|\
        2dgraphics|3dgraphics|art)                                     echo "Graphics"    ;;
        # Network / Internet
        internet|network|webbrowser|webdevelopment|email|\
        instantmessaging|ircclient|p2p|remoteaccess|feed|dialup|\
        telephony|telephonytools|videoconference)                       echo "Network"     ;;
        # Office / Productivity
        office|wordprocessor|spreadsheet|presentation|database|\
        calendar|ebook|dictionary|finance|publishing|ocr|texteditor|\
        flowchart|projectmanagement)                                   echo "Office"      ;;
        # Development
        development|ide|debugger|revisioncontrol|guidesigner|\
        programming|webdevelopment|java)                               echo "Development" ;;
        # Science / Education
        education|science|astronomy|biology|chemistry|geography|\
        geology|history|math|physics|geoscience|humanities|\
        literature|medicalsoftware|numericalanalysis|robotics|\
        computerscience|artificialintelligence)                        echo "Education"   ;;
        *)                                                             echo ""            ;;
    esac
}

# Build a complete XDG Categories= string.
#   $1  raw Category=/Catalog= value from LLFile  (e.g. "PlatformGame; Game;")
#   $2  BuildType  (LLGame | LLApp | ppGame | ppApp | ssApp)
_build_xdg_categories() {
    local raw="$1" bt="$2"
    local token result="" first_base=""

    # Normalise: collapse any whitespace around semicolons, strip edge semicolons
    raw="${raw//;  /;}"
    raw="${raw//; /;}"
    raw="${raw// ;/;}"
    raw="${raw#;}"
    raw="${raw%;}"

    case "$bt" in
        LLGame)
            # Always lead with Game; then append any *Game sub-categories
            result="Game;"
            IFS=';' read -ra _toks <<< "$raw"
            for token in "${_toks[@]}"; do
                token="${token## }"; token="${token%% }"
                [ -z "$token" ] && continue
                [[ "${token,,}" == "game" ]] && continue   # bare Game already added
                result="${result}${token};"
            done
            ;;
        *)
            # LLApp / ppApp / ssApp / ppGame
            # Collect tokens and find the XDG base from the first recognised one
            IFS=';' read -ra _toks <<< "$raw"
            for token in "${_toks[@]}"; do
                token="${token## }"; token="${token%% }"
                [ -z "$token" ] && continue
                result="${result}${token};"
                if [ -z "$first_base" ]; then
                    first_base="$(_xdg_base_for_cat "$token")"
                fi
            done
            [ -z "$first_base" ] && first_base="Utility"
            # Prepend base group if not already present in result
            case ";${result};" in
                *";${first_base};"*) ;;
                *) result="${first_base};${result}" ;;
            esac
            ;;
    esac

    # Sanitise: collapse doubled semicolons, ensure trailing semicolon
    while [[ "$result" == *";;"* ]]; do result="${result//;;/;}"; done
    [ "${result: -1}" != ";" ] && result="${result};"
    echo "$result"
}

# ---------------------------------------------------------------------------
# .desktop file creation
# ---------------------------------------------------------------------------
create_desktop_entry() {
    local title="$1" exec_cmd="$2" work_dir="$3" icon="$4"
    local categories="$5" terminal="${6:-false}" comment="${7:-}"
    local safe="${title// /.}"
    local dfile="$INSTALL_TMP/${safe}.desktop"
    log "Creating .desktop: $title"
    cat > "$dfile" <<EOF
[Desktop Entry]
Type=Application
Name=$title
Comment=$comment
Exec=$exec_cmd
Path=$work_dir
Icon=$icon
Categories=$categories
Terminal=$terminal
StartupNotify=true
EOF
    chmod 644 "$dfile"
    local uapps="$HOME/.local/share/applications"
    mkdir -p "$uapps"
    cp -f "$dfile" "$uapps/${safe}.desktop"; chmod 644 "$uapps/${safe}.desktop"
    log "  → user: $uapps/${safe}.desktop"
}

# ---------------------------------------------------------------------------
# Parse [Title.desktop] sections
# ---------------------------------------------------------------------------
parse_desktop_sections() {
    local file="$1" ap="$2"
    local in_d=0 d_title="" d_exec="" d_path="" d_icon="" d_cats="" d_term="false" d_cmt=""
    local line

    _fld() {
        if [ -n "$d_title" ] && [ -n "$d_exec" ]; then
            # Auto-derive XDG categories from the LLFile Category= field when
            # the [Title.desktop] section does not supply its own Categories= line.
            local _cats="$d_cats"
            if [ -z "$_cats" ]; then
                # CATEGORIES and BUILD_TYPE are globals set by main()
                _cats="$(_build_xdg_categories "${CATEGORIES:-}" "${BUILD_TYPE:-}")"
                [ -n "$_cats" ] && log "  (auto-categories from LLFile: $_cats)"
            fi
            create_desktop_entry \
                "$d_title" "$(expand_path "$d_exec" "$ap")" "$(expand_path "$d_path" "$ap")" \
                "$(expand_path "$d_icon" "$ap")" "$_cats" "$d_term" "$d_cmt"
        fi
        d_title=""; d_exec=""; d_path=""; d_icon=""; d_cats=""; d_term="false"; d_cmt=""; in_d=0
    }

    while IFS= read -r line; do
        line="${line%$'\r'}"
        if [[ "$line" =~ ^\[(.+)\.desktop\]$ ]]; then
            _fld; d_title="${BASH_REMATCH[1]}"; in_d=1; continue
        fi
        [[ "$line" =~ ^\[.+\]$ ]] && [ "$in_d" -eq 1 ] && { _fld; continue; }
        if [ "$in_d" -eq 1 ] && [[ "$line" == *=* ]]; then
            local k="${line%%=*}" v="${line#*=}"
            k="${k,,}"; k="${k#"${k%%[![:space:]]*}"}"; k="${k%"${k##*[![:space:]]}"}"
            v="${v#"${v%%[![:space:]]*}"}"; v="${v%"${v##*[![:space:]]}"}"
            case "$k" in
                exec)                d_exec="$v"  ;;
                path)                d_path="$v"  ;;
                icon)                d_icon="$v"  ;;
                categories)          d_cats="$v"  ;;
                terminal)            d_term="${v,,}" ;;
                comment|description) d_cmt="$v"   ;;
            esac
        fi
    done < "$file"
    _fld
}

# ---------------------------------------------------------------------------
# Parse [Title.lnk] sections  →  .desktop (wine exec) + optional wine .lnk
# ---------------------------------------------------------------------------
parse_lnk_sections() {
    local file="$1" ap="$2"
    local in_l=0 l_title="" l_tgt="" l_args="" l_desc="" l_icon="" l_wd="" l_cats=""
    local line

    _fll() {
        [ -n "$l_title" ] && [ -n "$l_tgt" ] && \
            _install_lnk "$l_title" "$l_tgt" "$l_args" "$l_desc" "$l_icon" "$l_wd" "$ap" "$l_cats"
        l_title=""; l_tgt=""; l_args=""; l_desc=""; l_icon=""; l_wd=""; l_cats=""; in_l=0
    }

    while IFS= read -r line; do
        line="${line%$'\r'}"
        if [[ "$line" =~ ^\[(.+)\.lnk\]$ ]]; then
            _fll; l_title="${BASH_REMATCH[1]}"; in_l=1; continue
        fi
        [[ "$line" =~ ^\[.+\]$ ]] && [ "$in_l" -eq 1 ] && { _fll; continue; }
        if [ "$in_l" -eq 1 ] && [[ "$line" == *=* ]]; then
            local k="${line%%=*}" v="${line#*=}"
            k="${k,,}"; k="${k#"${k%%[![:space:]]*}"}"; k="${k%"${k##*[![:space:]]}"}"
            v="${v#"${v%%[![:space:]]*}"}"; v="${v%"${v##*[![:space:]]}"}"
            case "$k" in
                target)           l_tgt="$v"   ;;
                arguments)        l_args="$v"  ;;
                description)      l_desc="$v"  ;;
                icon|iconfile)    l_icon="$v"  ;;
                workingdirectory) l_wd="$v"    ;;
                categories)       l_cats="$v"  ;;
            esac
        fi
    done < "$file"
    _fll
}

_install_lnk() {
    local title="$1" target="$2" args="$3" desc="$4" icon_raw="$5" wd_raw="$6" ap="$7" lnk_cats="${8:-}"
    log "Processing .lnk: $title"

    local linux_target linux_wd linux_icon safe _wd _tdir
    linux_target="$(expand_path "$target" "$ap")"
    # Resolve working dir: explicit > dirname of resolved target > app_path
    if [ -n "$wd_raw" ]; then
        _wd="$(expand_path "$wd_raw" "$ap")"
    else
        _tdir="$(dirname "$linux_target")"
        if [ "$_tdir" = "." ] || [ -z "$_tdir" ]; then
            _wd="$ap"
        else
            _wd="$_tdir"
        fi
    fi
    linux_wd="$_wd"
    safe="${title// /.}"

    # Icon resolution
    if [ -n "$icon_raw" ]; then
        linux_icon="$(expand_path "$icon_raw" "$ap")"
    else
        for ico in "$ap/ppGame.png" "$ap/ppApp.png" "$ap/ssApp.png" \
                   "$ap/LLGame.png" "$ap/ppGame.ico" "$ap/ppApp.ico"; do
            [ -f "$ico" ] && { linux_icon="$ico"; break; }
        done
        linux_icon="${linux_icon:-$ap/ppGame.png}"
    fi

    # Write a small launcher script so the exec line stays simple
    local launcher="$ap/${safe}.sh"
    {
        echo "#!/bin/bash"
        echo "cd '${linux_wd}'"
        if [ -n "$args" ]; then
            echo "exec wine '${linux_target}' ${args} \"\$@\""
        else
            echo "exec wine '${linux_target}' \"\$@\""
        fi
    } > "$launcher"
    chmod +x "$launcher"
    log "  Created launcher: $launcher"

    # Derive XDG categories: use explicit Categories= from the .lnk section if
    # provided, otherwise auto-derive from the LLFile Category= / BuildType.
    local _lnk_cats="$lnk_cats"
    if [ -z "$_lnk_cats" ]; then
        _lnk_cats="$(_build_xdg_categories "${CATEGORIES:-}" "${BUILD_TYPE:-}")"
        [ -n "$_lnk_cats" ] && log "  (auto-categories from LLFile: $_lnk_cats)"
    fi
    create_desktop_entry "$title" "bash '$launcher'" "$linux_wd" "$linux_icon" \
        "$_lnk_cats" "false" "$desc"

    # Optionally create the real .lnk in the wine prefix via wscript + VBScript
    if command -v wine &>/dev/null; then
        local wine_target wine_wd
        wine_target="$(expand_path_wine "$target" "$ap")"
        if [ -n "$wd_raw" ]; then
            wine_wd="$(expand_path_wine "$wd_raw" "$ap")"
        else
            local _wt; _wt="$(expand_path_wine "$target" "$ap")"
            local _wtd; _wtd="$(dirname "$_wt")"
            if [ "$_wtd" = "." ] || [ -z "$_wtd" ]; then
                wine_wd="$(_to_wine_path "$ap")"
            else
                wine_wd="$_wtd"
            fi
        fi
        local lnk_dir="$HOME/.wine/drive_c/users/$USER/Start Menu/Programs"
        mkdir -p "$lnk_dir" 2>/dev/null || true
        local vbs="$INSTALL_TMP/${safe}_lnk.vbs"
        cat > "$vbs" <<VBS
Set oShell = CreateObject("WScript.Shell")
Set oLink  = oShell.CreateShortcut("${lnk_dir}\\${title}.lnk")
oLink.TargetPath       = "${wine_target}"
oLink.WorkingDirectory = "${wine_wd}"
oLink.Description      = "${desc}"
oLink.Save
VBS
        wine wscript "$vbs" 2>&1 | while IFS= read -r l; do _log_raw "        $l"; done \
            && log "  wine .lnk created in prefix." \
            || warn "  wine wscript failed – .lnk not created (desktop shortcut still works)."
    fi
}

# ---------------------------------------------------------------------------
# XDG menu sorting
# ---------------------------------------------------------------------------
apply_menu_sorting() {
    local ms="$TOOLS_DIR/LinuxMenuSorting"
    [ -d "$ms" ] || { log "No LinuxMenuSorting, skipping."; return 0; }
    log "Applying XDG menu sorting..."
    local xu="${XDG_CONFIG_HOME:-$HOME/.config}/menus/applications-merged"
    mkdir -p "$xu"
    [ -d "$ms/xdg/menus/applications-merged" ] && \
        cp -f "$ms/xdg/menus/applications-merged/"*.menu "$xu/" 2>/dev/null || true

    # All build types that install into the user's home directory never need
    # system-wide XDG menu changes.  The user-level copy above is sufficient.
    #   LLGame / LLApp  → $HOME/LLGames or $HOME/LLApps
    #   ppGame / ppApp / ssApp → $HOME/.wine/...
    case "${BUILD_TYPE:-}" in
        LLGame|LLApp|ppGame|ppApp|ssApp)
            log "$BUILD_TYPE installs to user home – skipping system-wide XDG menu paths (no sudo needed)."
            return 0
            ;;
    esac

    # Only build types that install to system-wide paths (none currently defined,
    # but the block is kept here for forward compatibility) reach this point.
    if path_needs_sudo "/etc/xdg/menus"; then
        find_sudo
        [ -n "$SUDO_CMD" ] && [ -d "$ms/xdg/menus/applications-merged" ] && \
            run_sudo "mkdir -p /etc/xdg/menus/applications-merged && \
                cp -f '$ms/xdg/menus/applications-merged/'*.menu \
                       /etc/xdg/menus/applications-merged/ 2>/dev/null || true" || true
    fi
    if path_needs_sudo "/usr/share/desktop-directories"; then
        find_sudo
        [ -n "$SUDO_CMD" ] && [ -d "$ms/desktop-directories" ] && \
            run_sudo "mkdir -p /usr/share/desktop-directories && \
                cp -f '$ms/desktop-directories/'*.directory \
                       /usr/share/desktop-directories/ 2>/dev/null || true" || true
    else
        mkdir -p /usr/share/desktop-directories
        cp -f "$ms/desktop-directories/"*.directory \
               /usr/share/desktop-directories/ 2>/dev/null || true
    fi
}

refresh_desktop_db() {
    log "Refreshing desktop database..."
    command -v update-desktop-database &>/dev/null &&         update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
    command -v gtk-update-icon-cache &>/dev/null &&         gtk-update-icon-cache -f -t "$HOME/.local/share/icons" 2>/dev/null || true
}

# ---------------------------------------------------------------------------
# Run LLScript.sh  (normal user, no elevation)
# ---------------------------------------------------------------------------
run_bash_script() {
    local script="$1" ap="$2" label="${3:-script}"
    if [ ! -f "$script" ]; then log "No $label, skipping."; return 0; fi
    log "Running $label..."
    local exp; exp="$(expand_script_file "$script" "$ap")"
    chmod +x "$exp"
    bash "$exp" 2>&1 | while IFS= read -r l; do _log_raw "        $l"; done
    local rc="${PIPESTATUS[0]}"
    if [ "$rc" -eq 0 ]; then
        log "$label completed."
    else
        warn "$label exited non-zero (status $rc – continuing)."
    fi
    return "$rc"
}

# ---------------------------------------------------------------------------
# Run LLScript_Sudo.sh  – full privilege + full environment
# ---------------------------------------------------------------------------
run_sudo_script() {
    local script="$1" ap="$2"
    [ -f "$script" ] || return 0
    log "Running LLScript_Sudo.sh with elevated privileges..."

    local exp; exp="$(expand_script_file "$script" "$ap")"
    chmod +x "$exp"

    # ---------------------------------------------------------------------------
    # Save the expanded script for debugging – staged internally for now.
    # It is only written to the Desktop if the script fails.
    # ---------------------------------------------------------------------------
    {
        echo "======================================================"
        echo " LLStore Expanded LLScript_Sudo.sh  –  $(date)"
        echo " Source:   $script"
        echo " Expanded: $exp"
        echo "======================================================"
        cat "$exp"
        # Guarantee a trailing newline so the last line is always visible
        echo ""
        echo "======================================================"
    } > "$SCRIPT_EXPANDED_TMP" 2>/dev/null || true

    # Copy expanded script to /tmp so root can always reach it
    # (INSTALL_TMP may live under $HOME which root might not be able to read)
    local safe_script="/tmp/llstore_sudo_$$.sh"
    cp "$exp" "$safe_script"
    chmod 755 "$safe_script"

    # ------------------------------------------------------------------
    # Build the env-export wrapper.
    #
    # KEY FIX: When the wrapper is already running as root (EUID=0),
    # we override the shell `sudo` builtin to be a simple passthrough.
    # This is essential because LLScript_Sudo.sh's inst() function calls
    # `sudo apt install …` etc.  When already root, a nested sudo will
    # either re-prompt, fail due to requiretty, or be silently skipped –
    # which is why you saw echoed output but no package installs.
    # By making `sudo` a passthrough function we avoid all of that.
    # ------------------------------------------------------------------
    local env_wrapper="/tmp/llstore_sudo_env_$$.sh"
    cat > "$env_wrapper" <<ENV_EOF
#!/bin/bash
# LLStore env-export wrapper (auto-generated – do not edit)

# --- environment ---------------------------------------------------------
export HOME='$HOME'
export USER='$USER'
export LOGNAME='$USER'
export PATH='$PATH'
export LL_GAMES_ROOT='$LL_GAMES_ROOT'
export LL_APPS_ROOT='$LL_APPS_ROOT'
export PP_GAMES_ROOT='$PP_GAMES_ROOT'
export PP_APPS_ROOT='$PP_APPS_ROOT'
export SS_APPS_ROOT='$SS_APPS_ROOT'
export XDG_SESSION_DESKTOP='${XDG_SESSION_DESKTOP:-}'
export XDG_CURRENT_DESKTOP='${XDG_CURRENT_DESKTOP:-}'
export XDG_SESSION_TYPE='${XDG_SESSION_TYPE:-}'
export DISPLAY='${DISPLAY:-}'
export WAYLAND_DISPLAY='${WAYLAND_DISPLAY:-}'
export DBUS_SESSION_BUS_ADDRESS='${DBUS_SESSION_BUS_ADDRESS:-}'
export XDG_CONFIG_HOME='${XDG_CONFIG_HOME:-$HOME/.config}'
export XDG_DATA_HOME='${XDG_DATA_HOME:-$HOME/.local/share}'
export XDG_RUNTIME_DIR='${XDG_RUNTIME_DIR:-/run/user/$(id -u)}'

# --- sudo passthrough when already root ----------------------------------
# When this wrapper is invoked with elevated privileges the shell is already
# running as root.  The LLScript inst() helper (and any other code in the
# user's script) calls `sudo <pkg-manager> install …`.  A nested sudo with
# no TTY will fail silently on most distros (requiretty, pam_tty, etc.).
# Override sudo as a shell function so those calls just run directly.
if [ "\$(id -u)" = "0" ]; then
    sudo() {
        # Strip any sudo option flags that are not meaningful when root
        local _args=()
        while [ \$# -gt 0 ]; do
            case "\$1" in
                -E|-n|-H|-i|-s|-b|-k|-K|-l|-v|--reset-timestamp| \
                --non-interactive|--login|--shell|--background| \
                --list|--validate|--remove-timestamp)
                    shift ;;
                -u|-g|-r|-t|-p|-c|-T|-C|-D|-R|-P)
                    shift 2 ;;      # flags that take an argument
                --)
                    shift; break ;; # end of flags
                *)
                    _args+=("\$1"); shift ;;
            esac
        done
        "\${_args[@]}"
    }
    export -f sudo
fi

# --- run the actual script -----------------------------------------------
bash '$safe_script'
_EXIT=\$?

# Append script output marker to staging log (flushed to Desktop on error below)
echo "" >> '$SCRIPT_EXPANDED_TMP' 2>/dev/null || true
echo "Script exited with status: \$_EXIT" >> '$SCRIPT_EXPANDED_TMP' 2>/dev/null || true

exit \$_EXIT
ENV_EOF
    chmod 755 "$env_wrapper"

    # ------------------------------------------------------------------
    # Execute the wrapper under the appropriate privilege tool
    # ------------------------------------------------------------------
    local rc=0

    if [ "$EUID" -eq 0 ]; then
        # Already root – run directly (sudo override still in wrapper for safety)
        bash "$env_wrapper" 2>&1 | while IFS= read -r l; do _log_raw "        $l"; done
        rc="${PIPESTATUS[0]}"
        if [ "$rc" -ne 0 ]; then
            _flush_to_desktop
            cp "$SCRIPT_EXPANDED_TMP" "$DESKTOP_SCRIPT_LOG" 2>/dev/null || true
            warn "LLScript_Sudo.sh (root) exited with status $rc – see:"
            warn "  $DESKTOP_LOG"
            warn "  $DESKTOP_SCRIPT_LOG"
        fi
    else
        find_sudo
        if [ -z "$SUDO_CMD" ]; then
            warn "No privilege tool found – LLScript_Sudo.sh skipped."
            rm -f "$safe_script" "$env_wrapper"
            return 0
        fi
        log "Elevating with: $SUDO_CMD"

        case "$SUDO_CMD" in
            sudo)
                # Pass explicit env vars AND use -E to inherit the rest.
                # Using both is belt-and-suspenders: some sudoers configs
                # strip PATH/HOME even with -E.
                sudo -E \
                     HOME="$HOME" \
                     USER="$USER" \
                     LOGNAME="$USER" \
                     LL_GAMES_ROOT="$LL_GAMES_ROOT" \
                     LL_APPS_ROOT="$LL_APPS_ROOT" \
                     PP_GAMES_ROOT="$PP_GAMES_ROOT" \
                     PP_APPS_ROOT="$PP_APPS_ROOT" \
                     SS_APPS_ROOT="$SS_APPS_ROOT" \
                     DISPLAY="${DISPLAY:-}" \
                     WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-}" \
                     XDG_SESSION_DESKTOP="${XDG_SESSION_DESKTOP:-}" \
                     XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP:-}" \
                     DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-}" \
                     XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}" \
                     bash "$env_wrapper" \
                     2>&1 | while IFS= read -r l; do _log_raw "        $l"; done
                rc="${PIPESTATUS[0]}"
                ;;
            pkexec)
                pkexec env \
                    HOME="$HOME" USER="$USER" LOGNAME="$USER" PATH="$PATH" \
                    LL_GAMES_ROOT="$LL_GAMES_ROOT" \
                    LL_APPS_ROOT="$LL_APPS_ROOT" \
                    PP_GAMES_ROOT="$PP_GAMES_ROOT" \
                    PP_APPS_ROOT="$PP_APPS_ROOT" \
                    SS_APPS_ROOT="$SS_APPS_ROOT" \
                    XDG_SESSION_DESKTOP="${XDG_SESSION_DESKTOP:-}" \
                    XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP:-}" \
                    DISPLAY="${DISPLAY:-}" \
                    WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-}" \
                    DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-}" \
                    XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}" \
                    bash "$env_wrapper" \
                    2>&1 | while IFS= read -r l; do _log_raw "        $l"; done
                rc="${PIPESTATUS[0]}"
                ;;
            doas)
                doas env \
                    HOME="$HOME" USER="$USER" PATH="$PATH" \
                    LL_GAMES_ROOT="$LL_GAMES_ROOT" \
                    LL_APPS_ROOT="$LL_APPS_ROOT" \
                    bash "$env_wrapper" \
                    2>&1 | while IFS= read -r l; do _log_raw "        $l"; done
                rc="${PIPESTATUS[0]}"
                ;;
            kdesu|kdesudo|gksu)
                "$SUDO_CMD" bash "$env_wrapper" \
                    2>&1 | while IFS= read -r l; do _log_raw "        $l"; done
                rc="${PIPESTATUS[0]}"
                ;;
        esac

        if [ "$rc" -eq 0 ]; then
            log "LLScript_Sudo.sh completed successfully."
        else
            # Script failed – flush expanded script to Desktop for inspection
            _flush_to_desktop
            cp "$SCRIPT_EXPANDED_TMP" "$DESKTOP_SCRIPT_LOG" 2>/dev/null || true
            warn "LLScript_Sudo.sh exited with status $rc – see:"
            warn "  $DESKTOP_LOG"
            warn "  $DESKTOP_SCRIPT_LOG"
        fi
    fi

    rm -f "$safe_script" "$env_wrapper"
    return $rc
}

# ---------------------------------------------------------------------------
# Wine registry import
# ---------------------------------------------------------------------------
run_wine_registry() {
    local reg_file="$1" ap="$2"
    [ -f "$reg_file" ] || return 0
    if ! command -v wine &>/dev/null; then
        warn "Wine not found. Skipping registry import: $reg_file"; return 0
    fi
    log "Importing wine registry: $reg_file"
    local exp; exp="$(expand_reg_file "$reg_file" "$ap")"
    wine regedit.exe /s "$exp" 2>&1 | while IFS= read -r l; do _log_raw "        $l"; done \
        && log "Registry import complete." \
        || warn "Registry import failed (continuing)."
}

# ---------------------------------------------------------------------------
# Wine CMD script
# ---------------------------------------------------------------------------
run_wine_cmd() {
    local script="$1" ap="$2" label="${3:-wine cmd}"
    [ -f "$script" ] || return 0
    if ! command -v wine &>/dev/null; then
        warn "Wine not found. Skipping $label."; return 0
    fi
    log "Running wine $label: $script"
    local exp; exp="$(expand_cmd_file "$script" "$ap")"
    # Use the expanded (path-substituted) temp file, not the original source path.
    (cd "$(dirname "$script")" && wine cmd.exe /c "$(_to_wine_path "$exp")") \
        2>&1 | while IFS= read -r l; do _log_raw "        $l"; done \
        && log "$label complete." \
        || warn "$label failed (continuing)."
}

# ---------------------------------------------------------------------------
# Permissions fix
# ---------------------------------------------------------------------------
fix_permissions() {
    local ip="$1"
    [ -d "$ip" ] || return 0
    log "Setting permissions: $ip"
    if path_needs_sudo "$ip"; then
        find_sudo
        [ -z "$SUDO_CMD" ] && return 0
        run_sudo "
            find '$ip' -type d -exec chmod 755 {} \\; 2>/dev/null || true
            find '$ip' -type f \\( -name '*.sh' -o -name '*.py' -o -name '*.run' -o -name '*.AppImage' \\) \
                -exec chmod 755 {} \\; 2>/dev/null || true
            find '$ip' -type f ! -name '*.sh' ! -name '*.py' ! -name '*.run' ! -name '*.AppImage' \
                ! -perm /111 -exec chmod 644 {} \\; 2>/dev/null || true
        " 2>&1 | while IFS= read -r l; do _log_raw "        $l"; done || true
    else
        find "$ip" -type d -exec chmod 755 {} \; 2>/dev/null || true
        find "$ip" -type f \( -name "*.sh" -o -name "*.py" -o -name "*.pl" \
             -o -name "*.run" -o -name "*.AppImage" \) -exec chmod 755 {} \; 2>/dev/null || true
        find "$ip" -type f -perm /111 -exec chmod 755 {} \; 2>/dev/null || true
        find "$ip" -type f ! -perm /111 ! -name "*.sh" ! -name "*.py" \
             ! -name "*.pl" ! -name "*.run" ! -name "*.AppImage" \
             -exec chmod 644 {} \; 2>/dev/null || true
        find "$ip" -type f \( -name "*.sh" -o -name "*.py" \) \
             -exec chmod 755 {} \; 2>/dev/null || true
    fi
}

# ===========================================================================
# M A I N
# ===========================================================================
main() {
    log "======================================================"
    log " LLStore SFX Installer v3"
    log " SFX root:   $SFX_ROOT"
    log " Desktop log: $DESKTOP_LOG"
    log "======================================================"

    [ -f "$LINUX_7Z" ] && chmod +x "$LINUX_7Z" 2>/dev/null || true

    # ------------------------------------------------------------------
    # 1. Locate and parse the metadata file
    # ------------------------------------------------------------------
    LLFILE="$(find_llfile)" || { error "Cannot locate LLFile – aborting."; return 1; }
    log "LLFile: $LLFILE"

    INI_SECTION="$(llfile_section "$LLFILE")"
    log "INI section: [$INI_SECTION]"

    TITLE="$(get_field        "$LLFILE" "$INI_SECTION" "Title")"
    VERSION="$(get_field      "$LLFILE" "$INI_SECTION" "Version")"
    BUILD_TYPE="$(get_field   "$LLFILE" "$INI_SECTION" "BuildType")"
    RAW_APP_PATH="$(get_field "$LLFILE" "$INI_SECTION" "AppPath")"
    FLAGS="$(get_field        "$LLFILE" "$INI_SECTION" "Flags")"; FLAGS="${FLAGS,,}"
    DESCRIPTION="$(get_field  "$LLFILE" "$INI_SECTION" "Description")"
    CATEGORIES="$(get_field   "$LLFILE" "$INI_SECTION" "Category")"

    [ -z "$TITLE" ] && { error "Title= not found in LLFile – aborting."; return 1; }

    # Infer BuildType from file extension if not set in file
    if [ -z "$BUILD_TYPE" ]; then
        case "${LLFILE,,}" in
            *.llg) BUILD_TYPE="LLGame" ;;
            *.lla) BUILD_TYPE="LLApp"  ;;
            *.ppg) BUILD_TYPE="ppGame" ;;
            *.app)
                local _bt; _bt="$(get_field "$LLFILE" "SetupS" "BuildType")"
                BUILD_TYPE="${_bt:-ssApp}" ;;
        esac
    fi

    log "Title:     $TITLE"
    log "Version:   $VERSION"
    log "BuildType: $BUILD_TYPE"
    log "AppPath:   $RAW_APP_PATH"
    log "Flags:     $FLAGS"

    # ------------------------------------------------------------------
    # 2. NoInstall / ssApp detection
    #    ssApp never extracts a main archive (it runs purely through scripts)
    # ------------------------------------------------------------------
    NO_INSTALL=false
    if has_flag "$FLAGS" "noinstall" || [ "$BUILD_TYPE" = "ssApp" ]; then
        NO_INSTALL=true
        log "NoInstall/ssApp mode – archive extraction skipped."
    fi

    # ------------------------------------------------------------------
    # 3. Resolve AppPath
    # ------------------------------------------------------------------
    APP_PATH="$(expand_path "$RAW_APP_PATH" "")"
    log "Resolved AppPath: $APP_PATH"

    # ------------------------------------------------------------------
    # 4. Detect sudo script  (wine build types never use one)
    # ------------------------------------------------------------------
    SUDO_SCRIPT="$SFX_ROOT/LLScript_Sudo.sh"
    case "$BUILD_TYPE" in
        ppGame|ppApp|ssApp)
            if [ -f "$SUDO_SCRIPT" ]; then
                warn "LLScript_Sudo.sh found but ignored for wine build type ($BUILD_TYPE) – no sudo needed."
            fi
            SUDO_SCRIPT=""   # ensure step 12 is a no-op
            ;;
        *)
            if [ -f "$SUDO_SCRIPT" ]; then
                log "LLScript_Sudo.sh detected – locating privilege tool..."
                find_sudo
            fi
            ;;
    esac

    # ------------------------------------------------------------------
    # 5. Create install directory
    # ------------------------------------------------------------------
    if ! $NO_INSTALL || [ -n "$APP_PATH" ]; then
        log "Ensuring: $APP_PATH"
        make_dir "$APP_PATH"
    fi

    # ------------------------------------------------------------------
    # 6. Extract archives
    # ------------------------------------------------------------------
    if ! $NO_INSTALL; then
        # LLApp / LLGame  (tar-based)
        for cand in \
            "$SFX_ROOT/LLApp.tar.gz" "$SFX_ROOT/LLGame.tar.gz" \
            "$SFX_ROOT/LLApp.tar"    "$SFX_ROOT/LLGame.tar"    \
            "$SFX_ROOT/LLApp.7z"     "$SFX_ROOT/LLGame.7z"; do
            [ -f "$cand" ] && { extract_archive "$cand" "$APP_PATH"; break; }
        done

        # ppApp / ppGame  (7z-based)
        for cand in \
            "$SFX_ROOT/ppApp.7z"  "$SFX_ROOT/ppGame.7z" \
            "$SFX_ROOT/ppApp.apz" "$SFX_ROOT/ppGame.pgz"; do
            [ -f "$cand" ] && extract_archive "$cand" "$APP_PATH"
        done

        # Patch
        for cand in "$SFX_ROOT/Patch.7z" "$SFX_ROOT/patch.7z"; do
            [ -f "$cand" ] && { log "Applying patch: $cand"; extract_archive "$cand" "$APP_PATH"; }
        done
    fi

    # ------------------------------------------------------------------
    # 7. Copy media and metadata files to AppPath  (unless noinstall flag)
    # ------------------------------------------------------------------
    if ! has_flag "$FLAGS" "noinstall"; then
        log "Copying media and descriptor files..."
        for media in \
            LLApp.png LLGame.png ppGame.png ppApp.png ssApp.png \
            LLApp.jpg LLGame.jpg ppGame.jpg ppApp.jpg ssApp.jpg gameart.jpg \
            LLApp.ico LLGame.ico ppGame.ico ppApp.ico ssApp.ico \
            LLApp.svg LLGame.svg another-world.png; do
            [ -f "$SFX_ROOT/$media" ] && copy_file "$SFX_ROOT/$media" "$APP_PATH"
        done
        copy_file "$LLFILE" "$APP_PATH"
        # Per-BuildType descriptor copies (ppGame.ppg, ppApp.app, ssApp.app, .reg, .cmd)
        for desc in \
            "${BUILD_TYPE}.ppg" "${BUILD_TYPE}.app" \
            "${BUILD_TYPE}.reg" "${BUILD_TYPE}.cmd" \
            LLScript.sh; do
            [ -f "$SFX_ROOT/$desc" ] && copy_file "$SFX_ROOT/$desc" "$APP_PATH"
        done
        [ -f "$APP_PATH/LLScript.sh" ] && chmod 755 "$APP_PATH/LLScript.sh" 2>/dev/null || true
    fi

    # ------------------------------------------------------------------
    # 8. Fix permissions before running scripts
    # ------------------------------------------------------------------
    [ -d "$APP_PATH" ] && fix_permissions "$APP_PATH"

    # ------------------------------------------------------------------
    # 9. LLScript.sh  (normal user)
    # ------------------------------------------------------------------
    run_bash_script "$SFX_ROOT/LLScript.sh" "$APP_PATH" "LLScript.sh"

    # ------------------------------------------------------------------
    # 10. Wine registry import
    # ------------------------------------------------------------------
    local reg_file=""
    for cand in \
        "$APP_PATH/${BUILD_TYPE}.reg" "$SFX_ROOT/${BUILD_TYPE}.reg" \
        "$APP_PATH/LLApp.reg"         "$SFX_ROOT/LLApp.reg" \
        "$APP_PATH/LLGame.reg"        "$SFX_ROOT/LLGame.reg"; do
        [ -f "$cand" ] && { reg_file="$cand"; break; }
    done
    run_wine_registry "$reg_file" "$APP_PATH"

    # ------------------------------------------------------------------
    # 11. Wine CMD script
    # ------------------------------------------------------------------
    local wcmd=""
    for cand in \
        "$SFX_ROOT/${BUILD_TYPE}.cmd" "$APP_PATH/${BUILD_TYPE}.cmd" \
        "$SFX_ROOT/LLScript.cmd"      "$APP_PATH/LLScript.cmd"; do
        [ -f "$cand" ] && { wcmd="$cand"; break; }
    done
    run_wine_cmd "$wcmd" "$APP_PATH" "${BUILD_TYPE}.cmd"

    # ------------------------------------------------------------------
    # 12. LLScript_Sudo.sh  (elevated)
    # ------------------------------------------------------------------
    run_sudo_script "$SUDO_SCRIPT" "$APP_PATH"

    # ------------------------------------------------------------------
    # 13. .desktop shortcuts
    # ------------------------------------------------------------------
    log "Processing [Title.desktop] sections..."
    parse_desktop_sections "$LLFILE" "$APP_PATH"

    # ------------------------------------------------------------------
    # 14. .lnk shortcuts  (ppGame / ppApp / ssApp)
    # ------------------------------------------------------------------
    log "Processing [Title.lnk] sections..."
    parse_lnk_sections "$LLFILE" "$APP_PATH"

    # ------------------------------------------------------------------
    # 15. XDG menu sorting
    # ------------------------------------------------------------------
    apply_menu_sorting

    # ------------------------------------------------------------------
    # 16. Refresh desktop database
    # ------------------------------------------------------------------
    refresh_desktop_db

    # ------------------------------------------------------------------
    # 17. Final permission pass
    # ------------------------------------------------------------------
    [ -d "$APP_PATH" ] && fix_permissions "$APP_PATH"

    log ""
    log "======================================================"
    log " Complete: $TITLE $VERSION  [$BUILD_TYPE]"
    [ -d "$APP_PATH" ] && log " Location:  $APP_PATH"
    if [ "$_HAD_ISSUE" -eq 1 ]; then
        log " Error log: $DESKTOP_LOG"
        [ -f "$DESKTOP_SCRIPT_LOG" ] && log " Script:    $DESKTOP_SCRIPT_LOG"
    fi
    log "======================================================"

    if in_terminal; then
        echo ""
        echo "  ✓ $TITLE ${VERSION:+($VERSION)} [$BUILD_TYPE] installed."
        [ -d "$APP_PATH" ] && echo "    Location: $APP_PATH"
        if [ "$_HAD_ISSUE" -eq 1 ]; then
            echo "    Issues were logged to: $DESKTOP_LOG"
            [ -f "$DESKTOP_SCRIPT_LOG" ] && \
                echo "    Expanded script:      $DESKTOP_SCRIPT_LOG"
        fi
        echo ""
    fi
}

main "$@"
