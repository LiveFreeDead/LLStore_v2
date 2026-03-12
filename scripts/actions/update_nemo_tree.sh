#!/bin/bash
# update_nemo_tree.sh
# Ensures the "LastOS Tools" submenu exists in Nemo's actions-tree.json
# containing all 5 lastos-llfile actions. Removes stale flat entries from
# older installs. Safe to re-run on reinstall.
#
# Usage: update_nemo_tree.sh <path-to-actions-tree.json>

TREE="${1:-$HOME/.config/nemo/actions-tree.json}"
mkdir -p "$(dirname "$TREE")"

# No file yet — write minimal valid structure and exit
if [ ! -f "$TREE" ]; then
cat > "$TREE" << 'NEMOEOF'
{
  "toplevel": [
    {
      "uuid": "LastOS Tools",
      "type": "submenu",
      "user-label": "LastOS Tools",
      "user-icon": null,
      "children": [
        {"uuid":"lastos-llfile-install.nemo_action","type":"action","user-label":null,"user-icon":null},
        {"uuid":"lastos-llfile-editor.nemo_action","type":"action","user-label":null,"user-icon":null},
        {"uuid":"lastos-llfile-extract.nemo_action","type":"action","user-label":null,"user-icon":null},
        {"uuid":"lastos-llfile-compress.nemo_action","type":"action","user-label":null,"user-icon":null},
        {"uuid":"lastos-llfile-build.nemo_action","type":"action","user-label":null,"user-icon":null}
      ]
    }
  ]
}
NEMOEOF
    exit 0
fi

# File exists — use awk to update it in one pass:
#   - Buffer each toplevel item
#   - Drop stale flat entries (llfile_install, llfile_edit) from old installs
#   - Replace the LastOS Tools submenu children if it exists, or append it
#   - uuid is captured only from the 6-space field line to avoid being
#     overwritten by child item uuids inside a submenu object
awk '
BEGIN {
    lastos  = "    {\n"
    lastos  = lastos "      \"uuid\": \"LastOS Tools\",\n"
    lastos  = lastos "      \"type\": \"submenu\",\n"
    lastos  = lastos "      \"user-label\": \"LastOS Tools\",\n"
    lastos  = lastos "      \"user-icon\": null,\n"
    lastos  = lastos "      \"children\": [\n"
    lastos  = lastos "        {\n          \"uuid\": \"lastos-llfile-install.nemo_action\",\n          \"type\": \"action\",\n          \"user-label\": null,\n          \"user-icon\": null\n        },\n"
    lastos  = lastos "        {\n          \"uuid\": \"lastos-llfile-editor.nemo_action\",\n          \"type\": \"action\",\n          \"user-label\": null,\n          \"user-icon\": null\n        },\n"
    lastos  = lastos "        {\n          \"uuid\": \"lastos-llfile-extract.nemo_action\",\n          \"type\": \"action\",\n          \"user-label\": null,\n          \"user-icon\": null\n        },\n"
    lastos  = lastos "        {\n          \"uuid\": \"lastos-llfile-compress.nemo_action\",\n          \"type\": \"action\",\n          \"user-label\": null,\n          \"user-icon\": null\n        },\n"
    lastos  = lastos "        {\n          \"uuid\": \"lastos-llfile-build.nemo_action\",\n          \"type\": \"action\",\n          \"user-label\": null,\n          \"user-icon\": null\n        }\n"
    lastos  = lastos "      ]\n"
    lastos  = lastos "    }"
    state = "normal"; buf = ""; uuid = ""; n = 0; lastos_done = 0
    in_header = 1; header = ""
}
in_header {
    if ($0 ~ /^    \{$/) {
        in_header = 0; state = "obj"; buf = $0 "\n"; uuid = ""
    } else {
        header = header $0 "\n"
    }
    next
}
state == "obj" {
    if ($0 ~ /^    \},?$/) {
        buf = buf "    }"
        if (uuid == "llfile_install.nemo_action" || uuid == "llfile_edit.nemo_action") {
            buf = ""; uuid = ""; state = "normal"; next
        }
        if (uuid == "LastOS Tools") {
            items[n++] = lastos; lastos_done = 1
            buf = ""; uuid = ""; state = "normal"; next
        }
        items[n++] = buf; buf = ""; uuid = ""; state = "normal"
    } else {
        if ($0 ~ /^      "uuid"/) {
            tmp = $0; gsub(/.*"uuid": "/, "", tmp); gsub(/".*/, "", tmp); uuid = tmp
        }
        buf = buf $0 "\n"
    }
    next
}
state == "normal" && /^    \{$/ { state = "obj"; buf = $0 "\n"; uuid = ""; next }
/^  \]/ {
    if (!lastos_done) items[n++] = lastos
    printf "%s", header
    for (i = 0; i < n; i++) {
        if (i < n-1) print items[i] ","
        else print items[i]
    }
    print "  ]"; state = "tail"; next
}
state == "tail" { print; next }
' "$TREE" > "${TREE}.tmp" && mv "${TREE}.tmp" "$TREE"
