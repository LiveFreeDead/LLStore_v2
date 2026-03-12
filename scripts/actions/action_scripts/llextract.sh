#!/bin/bash
# Extract LL and PP Archives
# Called by Nemo with a single outer archive (.tar / .apz / .pgz).
# Creates a subfolder named after the archive, extracts into it,
# then extracts any inner LL/PP archives found inside and deletes them.
# Deletes the outer archive on success.

item="$1"
[ -f "$item" ] || exit 1

filename="$(basename "$item")"
parent_dir="$(dirname "$item")"
dest="$parent_dir/${filename%.*}"

echo "Outer archive: $filename  →  $dest"
mkdir -p "$dest"
cd "$parent_dir" || exit 1

case "$filename" in
    *.tar)       tar -xf  "$filename" -C "$dest"; status=$? ;;
    *.apz|*.pgz) 7z x     "$filename" -o"$dest";  status=$? ;;
    *)           echo "Unsupported format: $filename"; exit 1 ;;
esac

[ $status -eq 0 ] || { echo "ERROR extracting outer archive: $filename"; exit 1; }

echo "Outer extraction OK — scanning for inner archives"

for archive in "$dest/LLGame.tar.gz" "$dest/LLApp.tar.gz" \
               "$dest/ppGame.7z"     "$dest/ppApp.7z"; do
    [ -f "$archive" ] || continue
    inner="$(basename "$archive")"
    echo "  Found inner archive: $inner"
    cd "$dest" || continue
    case "$inner" in
        *.tar.gz) tar -xzf "$inner"; s=$? ;;
        *.7z)     7z x     "$inner"; s=$? ;;
    esac
    if [ $s -eq 0 ]; then
        echo "  Extracted OK — deleting: $inner"
        rm -f "$archive"
    else
        echo "  ERROR extracting: $inner"
    fi
done

echo "Deleting outer archive: $filename"
rm -f "$item"

exit 0
