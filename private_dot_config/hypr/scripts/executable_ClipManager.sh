#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Clipboard Manager. This script uses cliphist, rofi, and wl-copy.

# Variables
rofi_theme="$HOME/.config/rofi/config-clipboard.rasi"

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

rofi -show cliphist-rofi-img -show-icons -kb-custom-1 'Control-Delete' -kb-custom-2 'Alt-Delete' -config "$rofi_theme"
