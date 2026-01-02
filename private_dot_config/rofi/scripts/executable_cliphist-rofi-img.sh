#!/usr/bin/env bash

# --- Configuration ---
tmp_dir="/tmp/cliphist"
msg='CTRL DEL = cliphist del (entry)   or   ALT DEL - cliphist wipe (all)'

# Ensure tmp directory exists
mkdir -p "$tmp_dir"

echo -en "\0message\x1f${msg}\n"
echo -en '\0use-hot-keys\x1ftrue\n'
# --- Logic ---

# ROFI_RETV determines the action:
# 0: Initial call (display list)
# 1: User pressed Enter (select)
# 10: User pressed kb-custom-1 (Delete)
# 11: User pressed kb-custom-2 (Wipe)

if [[ "$ROFI_RETV" -eq 1 ]]; then
	# Decode selection to clipboard
	cliphist decode <<<"$1" | wl-copy
	exit 0
elif [[ "$ROFI_RETV" -eq 10 ]]; then
	# Delete specific entry and keep script running to refresh list
	cliphist delete <<<"$1"
elif [[ "$ROFI_RETV" -eq 11 ]]; then
	# Wipe and exit
	cliphist wipe
	exit 0
fi

# --- List Generation (Initial or after deletion) ---

# Gawk processes the list to create icons for binary data
read -r -d '' prog <<EOF
/^[0-9]+\s<meta http-equiv=/ { next }
match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
    img_path="$tmp_dir/"grp[1]"."grp[3]
    # Only generate if it doesn't exist to save I/O
    if (system("test -f " img_path) != 0) {
        system("echo " grp[1] "\\\\\t | cliphist decode > " img_path)
    }
    print \$0"\0icon\x1f"img_path
    next
}
1
EOF

cliphist list | gawk "$prog"
